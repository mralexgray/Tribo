//
//  TBSiteWindowController.m
//  Tribo
//
//  Created by Carter Allen on 10/21/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//
#import "AZWebPreviewViewController.h"
#import "TBSiteWindowController.h"
#import "TBPostsViewController.h"
#import "TBTemplatesViewController.h"
#import "TBSourceViewControllerViewController.h"
#import "TBAddPostSheetController.h"
#import "TBSettingsSheetController.h"
#import "TBPublishSheetController.h"
#import "TBStatusViewController.h"
#import "TBTabView.h"
#import "TBSiteDocument.h"
#import "TBSite.h"
#import "TBMacros.h"
#import "NSResponder+TBAdditions.h"

const NSEdgeInsets TBAccessoryViewInsets = {
	.top = 0.0,
	.right = 4.0
};

@interface 				 				 TBSiteWindowController () <TBTabViewDelegate>
@property (nonatomic,assign) IBOutlet 	      NSSplitView * splitView;
@property (nonatomic,assign) IBOutlet 				  NSView * accessoryView;
@property (nonatomic,assign) IBOutlet 				  NSMenu * actionMenu;
@property (nonatomic,assign) IBOutlet 			  TBTabView * tabView;
@property (nonatomic,assign) IBOutlet 				  NSView * containerView;
@property (nonatomic,assign) IBOutlet NSLayoutConstraint * containerViewBottomConstraint;
@property (nonatomic) 									  NSView * currentView;
@property (nonatomic)           TBAddPostSheetController * addPostSheetController;
@property (nonatomic)          TBSettingsSheetController * settingsSheetController;
@property (nonatomic)           TBPublishSheetController * publishSheetController;
@property (nonatomic)             TBStatusViewController * statusViewController;
@property (weak)     IBOutlet AZWebPreviewViewController * webPreviewController;
- (void)toggleStatusView;
@end

@implementation TBSiteWindowController

- (id)init {	self = [super initWithWindowNibName:@"TBSiteWindow"];	return self; }

#pragma mark - View Controller Management

- (TBViewController *)selectedViewController { return _viewControllers[self.selectedViewControllerIndex]; }

- (void)setSelectedViewControllerIndex:(NSUInteger)selectedViewControllerIndex {

	_selectedViewControllerIndex 	= selectedViewControllerIndex;
	NSView *newView 					= (NSView*)[_viewControllers[_selectedViewControllerIndex] view];
	if (_currentView == newView)	return;
	if (_currentView)					[_currentView removeFromSuperview];
	newView.frame 				 		= _containerView.bounds;
	newView.autoresizingMask 		= NSViewWidthSizable|NSViewHeightSizable;
	[_containerView addSubview:self.currentView = newView];
}

- (void)setViewControllers:(NSA*)viewControllers {
	_viewControllers 				= viewControllers;
	_tabView.titles 				= [_viewControllers valueForKey:@"title"];
	_tabView.selectedIndex 		= _selectedViewControllerIndex;
}

- (IBAction)switchToPosts:		(id)x { _tabView.selectedIndex = 0; }
- (IBAction)switchToTemplates:(id)x { _tabView.selectedIndex = 1; }
- (IBAction)switchToSources:	(id)x { _tabView.selectedIndex = 2; }

- (IBAction)showAddPostSheet:(id)x {

	TBSiteDocument *document = (TBSiteDocument*)self.document;
	[self.addPostSheetController runModalForWindow:document.windowForSheet completionBlock:^(NSString*title, NSString *slug) {  NSError *error = nil;
        NSURL *siteURL = [document.site addPostWithTitle:title slug:slug error:&error];
        if (!siteURL)    [self tb_presentErrorOnMainQueue:error];
	}];
}

- (IBAction)showActionMenu:(id)sender {

	NSPoint clickedPoint = [NSApp currentEvent].locationInWindow;
	NSEvent *event = [NSEvent mouseEventWithType:NSRightMouseDown location:clickedPoint modifierFlags:0 timestamp:0.0 windowNumber:self.window.windowNumber context:NSGraphicsContext.currentContext eventNumber:1 clickCount:1 pressure:0.0];
	[NSMenu popUpContextMenu:self.actionMenu withEvent:event forView:self.accessoryView];
}

- (IBAction)preview:(id)sender {
	TBSiteDocument *document 		= (TBSiteDocument *)self.document;
	document.webView 					= self.webPreviewController;
	NSMenuItem *previewMenuItem 	= (NSMenuItem *)sender;
	if (!document.previewIsRunning) {
		[self toggleStatusView];
		self.statusViewController.title = @"Starting local preview...";
		
		[document startPreview:^(NSURL *localURL, NSError *error) {
			[((WebView*)document.webView.view).mainFrame loadRequest:[NSURLRequest requestWithURL:localURL]];
			if (error) 	return [self tb_presentErrorOnMainQueue:error], [self toggleStatusView];
			previewMenuItem.title = @"Stop Preview";
			self.statusViewController.title = @"Local preview running";
			self.statusViewController.link = localURL;
			MAWeakSelfDeclare();
			[self.statusViewController setStopHandler:^() { MAWeakSelfImport(); [self preview:sender]; }];
		}];
	}
	else { previewMenuItem.title = @"Preview";  [document stopPreview]; [self toggleStatusView]; }
}

- (IBAction)publish:(id)sender {
	[self.publishSheetController runModalForWindow:self.window site:[self.document site]];
}

- (IBAction)showSettingsSheet:(id)sender {
	[self.settingsSheetController runModalForWindow:self.window site:[self.document site]];
}

- (void)toggleStatusView {

	NSTimeInterval animationDuration = 0.1;
	[NSAnimationContext beginGrouping];
	NSAnimationContext.currentContext.duration = animationDuration;
	NSView *statusView 				= self.statusViewController.view;
	NSRect hiddenStatusViewFrame	= (NSRect){ {0, -statusView.frame.size.height}, 
				{self.containerView.frame.size.width, statusView.frame.size.height}};
//	NSRect splitPaneRect = [_splitView.subviews[1] frame];
	CGFloat offset = statusView.frame.size.height;
	NSRect fullContainer = _containerView.frame;
	NSRect displayedStatusViewFrame = hiddenStatusViewFrame;
	displayedStatusViewFrame.origin.y = 0.0;
	if (statusView.superview) {
		
		fullContainer.origin.y -= offset;
		fullContainer.size.height += offset;
		[NSAnimationContext.currentContext setCompletionHandler:^{	[statusView removeFromSuperview]; }];
		[statusView.animator setFrame:hiddenStatusViewFrame];
		[self.containerView.animator setFrame:fullContainer];
//		self.containerViewBottomConstraint.animator.constant = 0;
	}
	else {
		fullContainer.origin.y    +=offset;	
		fullContainer.size.height -=offset;
		statusView.autoresizingMask = NSViewWidthSizable;
		statusView.frame = hiddenStatusViewFrame;
		[self.containerView.superview addSubview:statusView];
		self.containerView.animator.frame = fullContainer;
		statusView.animator.frame = displayedStatusViewFrame;
		
//		self.containerViewBottomConstraint.animator.constant = -1 * statusView.frame.size.height;
	}
	[NSAnimationContext endGrouping];
}

#pragma mark - Tab View Delegate Methods

- (void)tabView:(TBTabView *)tabView didSelectIndex:(NSUInteger)index {
	self.selectedViewControllerIndex = index;
}

#pragma mark - Window Delegate Methods

- (void)windowDidLoad {
	[super windowDidLoad];
	
	self.addPostSheetController 	= TBAddPostSheetController.new;
	self.settingsSheetController 	= TBSettingsSheetController.new;
	self.publishSheetController 	= TBPublishSheetController.new;
	self.statusViewController 		= TBStatusViewController.new;
	
	NSView *themeFrame 		= [self.window.contentView superview];
	NSRect accessoryFrame 	= self.accessoryView.frame;
	NSRect containerFrame 	= themeFrame.frame;

	accessoryFrame = NSMakeRect(	   
											  containerFrame.size.width  - accessoryFrame.size.width  - 
		TBAccessoryViewInsets.right, containerFrame.size.height - accessoryFrame.size.height -
	   TBAccessoryViewInsets.top,   accessoryFrame.size.width,   accessoryFrame.size.height);

	self.accessoryView.frame = accessoryFrame;    
	self.accessoryView.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin;
	[[(NSButton *)self.accessoryView cell] setBackgroundStyle:NSBackgroundStyleRaised];
	[[(NSButton *)self.accessoryView cell] setShowsStateBy:NSPushInCellMask];
	[[(NSButton *)self.accessoryView cell] setHighlightsBy:NSContentsCellMask];
	[themeFrame addSubview:self.accessoryView];
	
									 TBPostsViewController * postsViewController;
							   TBTemplatesViewController * templatesController;
	          TBSourceViewControllerViewController * sourcesController;
	self.viewControllers = @[ 	postsViewController = TBPostsViewController.new, 
										templatesController = TBTemplatesViewController.new, 
										sourcesController   = TBSourceViewControllerViewController.new];
										
	postsViewController.document 	= 
	templatesController.document 	= 
   sourcesController.document 	= self.document;

	self.selectedViewControllerIndex = 0;
	
}

@end
