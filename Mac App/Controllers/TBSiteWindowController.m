
@import AtoZ;
#import "TBSiteWindowController.h"

const NSEdgeInsets TBAccessoryViewInsets = {	.top = 0.0,	.right = 4.0	};

@implementation TBSiteWindowController

- (id)init { return self = [super initWithWindowNibName:@"TBSiteWindow"]; }

#pragma mark - Window Delegate Methods

- (void) awakeFromNib {
		
	NSView* themeFrame 	= [self.window.contentView superview];
	_accessoryView.frame = (NSRect){{ 	themeFrame.width  - _accessoryView.width  - TBAccessoryViewInsets.right,
												themeFrame.height - _accessoryView.height - TBAccessoryViewInsets.top }, 
																		{ _accessoryView.width,  	      _accessoryView.height }};
	
	_accessoryView.autoresizingMask 	= NSViewMinXMargin|NSViewMinYMargin;
	
	[((NSButton*)self.accessoryView).cell setBackgroundStyle:NSBackgroundStyleRaised];
	[((NSButton*)self.accessoryView).cell    setShowsStateBy:       NSPushInCellMask];
	[((NSButton*)self.accessoryView).cell    setHighlightsBy:     NSContentsCellMask];

	[themeFrame addSubview:_accessoryView];
		
	self.viewControllers = @[ 	 TBPostsViewController.new, 
										 TBTemplatesViewController.new, 
										 TBSourceViewControllerViewController.new];
//	CAL*u	= [_containerView setupHostView];
//	u.bgC= cgBLUE;
	__block NSRect startRect = self.containerView.bounds;

	self.containerView.subviews = [_viewControllers map:^id(id obj) {
		[obj setValue:self.document forKey:@"document"];
		[(NSView*)[obj view] setFrame:startRect];
		[(NSView*)[obj view] setAutoresizingMask:NSSIZEABLE];
		startRect.origin.x += startRect.size.width;
		return [obj view];
	}];
		
	_addPostSheetController = TBAddPostSheetController .new;
	_settingsSheetController = TBSettingsSheetController.new;
	_publishSheetController = TBPublishSheetController .new;
	_statusViewController = TBStatusViewController   .new;
	
	
	[_tabView setTitles:[_viewControllers vFKP:@"title"]];

	AZBlockSelf(bSelf);
	_tabView.tabReceivedMouseDown = ^(TBTabView* tabView, TBTab*tab){

		//(void)tabView:(TBTabView*)tabView didSelectIndex:(NSUInteger)index { //__block id v = nil;
		NSUI index = [tabView.subviews indexOfObject:tab];
		[NSAnimationContext beginGrouping];
		NSAnimationContext.currentContext.duration = .5;
		NSRect nowRect = bSelf.currentView.bounds;
		nowRect.origin.x = nowRect.size.width;
		[bSelf.currentView.animator setFrame:nowRect];

		TBViewController *c __weak = [bSelf.viewControllers normal:index];
		nowRect.origin.x =  -bSelf.containerView.width;
		[c.view setFrame:nowRect];
		[bSelf.containerView addSubview:c.view];
		NSAnimationContext.currentContext.completionHandler = ^{
//			bSelf.currentView.alphaValue= 0;
//			bSelf.currentView.originX = - bSelf.containerView.width;
			[bSelf.currentView removeFromSuperview];
			bSelf.currentView = c.view;
		};
//		[c.view setAlphaValue:1];
		[c.view.animator setFrame:bSelf.containerView.bounds];
		[NSAnimationContext endGrouping];
	};

	
	_leftRight.dividerDrawingHandler = ^(NSRect dividerRect) { NSRectFillWithColor(dividerRect,[NSColor redColor]); };
	
	self.aceView.highlightActiveLine 			=
	self.aceView.wrappingBehavioursEnabled 	=
	self.aceView.useSoftWrap 						= YES;
	self.aceView.showFoldWidgets	 				= YES;
//	_aceView.themes s
//	self.aceView.mode 								= ACEModeHandlebars;
//	self.aceView.theme 								= ACEThemeMonokai;
	self.aceView.showPrintMargin 					= NO;
}


#pragma mark - View Controller Management

- (TBSiteDocument*) siteDoc {  return (TBSiteDocument*)self.document; }

- (IBAction) showAddPostSheet:(id)x {

	[self.addPostSheetController runModalForWindow:self.siteDoc.windowForSheet completionBlock:^(NSString*title, NSString *slug) {  NSError *e = nil;

        NSURL *siteURL; if (!(siteURL = [self.siteDoc.site addPostWithTitle:title slug:slug error:&e])) [self tb_presentErrorOnMainQueue:e];
	}];
}
- (IBAction)showActionMenu:(id)sender {

	[NSMenu popUpContextMenu:self.actionMenu withEvent:
		[NSEvent mouseEventWithType:NSRightMouseDown location:[NSApp currentEvent].locationInWindow modifierFlags:0 timestamp:0 
							windowNumber:self.window.windowNumber context:NSGraphicsContext.currentContext eventNumber:1 clickCount:1 pressure:0]
			 forView:self.accessoryView];
}

- (IBAction)preview:(id)sender {

	self.siteDoc.webView 			= self.webPreviewController;
	NSMenuItem *previewMenuItem 	= (NSMenuItem*)sender;
	if(self.siteDoc.previewIsRunning) { previewMenuItem.title = @"Preview";  [self.siteDoc stopPreview]; [self toggleStatusView];  return; }
	[self toggleStatusView];
	self.statusViewController.title = @"Starting local preview...";
	
	[self.siteDoc startPreview:^(NSURL *localURL, NSError *error) {
		[((WebView*)self.siteDoc.webView.view).mainFrame loadRequest:[NSURLRequest requestWithURL:localURL]];
		if (error) 	return [self tb_presentErrorOnMainQueue:error], [self toggleStatusView];
		previewMenuItem.title = @"Stop Preview";
		self.statusViewController.title = @"Local preview running";
		self.statusViewController.link = localURL;
		MAWeakSelfDeclare();
		[self.statusViewController setStopHandler:^() { MAWeakSelfImport(); [self preview:sender]; }];
	}];
}

- (IBAction)publish:				(id)x {	[self.publishSheetController runModalForWindow:self.window site:self.siteDoc.site]; 	}
- (IBAction)showSettingsSheet:(id)x {	[self.settingsSheetController runModalForWindow:self.window site:self.siteDoc.site];	}

- (void)toggleStatusView {

//	NSTimeInterval animationDuration = 0.1;
//	[NSAnimationContext beginGrouping];
//	NSAnimationContext.currentContext.duration = animationDuration;

	NSView *statusView 					= self.statusViewController.view;
	NSRect hiddenStatusViewFrame		= (NSRect){ {0, -statusView.height}, {self.containerView.width, statusView.height}};
//	NSRect splitPaneRect = [_splitView.subviews[1] frame];
	CGFloat offset 						= statusView.height;
	NSRect fullContainer 				= _containerView.frame;
	NSRect displayedStatusViewFrame 	= hiddenStatusViewFrame;
	displayedStatusViewFrame.origin.y = 0;
	if (statusView.superview) {
		
		fullContainer.origin.y -= offset;
		fullContainer.size.height += offset;
//		[NSAnimationContext.currentContext setCompletionHandler:^{	[statusView removeFromSuperview]; }];
		[statusView.animator setFrame:hiddenStatusViewFrame];
		[self.containerView.animator setFrame:fullContainer];
//		self.containerViewBottomConstraint.animator.constant = 0;
	}
	else {
		fullContainer.origin.y    +=offset;	
		fullContainer.size.height -=offset;
//		statusView.autoresizingMask = NSViewWidthSizable;
		statusView.frame = hiddenStatusViewFrame;
		[self.containerView.superview addSubview:statusView];
		[self.containerView.animator setFrame:fullContainer];
		[statusView.animator setFrame:displayedStatusViewFrame];
		
//		self.containerViewBottomConstraint.animator.constant = -1 * statusView.frame.size.height;
	}
//	[NSAnimationContext endGrouping];
}

@end

#pragma mark - Tab View Delegate Methods

//- (void)tabView:(TBTabView*)tabView didSelectIndex:(NSUInteger)index { //__block id v = nil;
//
//	[NSAnimationContext beginGrouping];
//	NSAnimationContext.currentContext.duration = 1;
////	if (_containerView.subviews.count) {
//
////		[v unbind:@"frame"];
//		[_currentView.animator setFrame:AZRectExceptOriginX(_currentView.frame,_currentView.width)];
//
////	}
//	TBViewController *c = [_viewControllers normal:index];
//	NSAnimationContext.currentContext.completionHandler = ^{  
//		self.currentView.alphaValue= 0;
//		self.currentView.originX = -self.containerView.width;
//		self.currentView = c.view; 
//	};
//		//	XX([c class]);
//
////	XX(self.currentView.frame);
//	[c.view setAlphaValue:1];
////	[self.containerView addSubview:newV];
////	[c.view setFrame:AZRectExceptOriginX(_containerView.bounds,_containerView.width)];
//	[c.view.animator setFrame:_containerView.bounds];
////	XX(newV);
////	[newV bind:@"frame" toObject:_containerView withKeyPath:@"bounds" options:nil];
////	[_currentView fadeIn];
////	[_containerView setNeedsDisplay:YES];
//	[NSAnimationContext endGrouping];
//}

//	 				= [_viewControllers valueForKey:@"title"];
//	_tabView.selectedIndex 		= _selectedViewControllerIndex;

//	[self tabView:_tabView didSelectIndex:0];
//	postsViewController.document 	= 
//	templatesController.document 	= 
//   sourcesController.document 	= self.document;

//	self.selectedViewControllerIndex = 0;
//	AZBlockSelf(bSelf);
//	[self.leftRight.subviews[1] bind:@"subviews" toObject:self withKeyPath:@"selectedViewController.view" options:nil];
//	[self.currentView bind:@"frame" toObject:self.containerView withKeyPath:@"bounds" options:nil];	
	
	//transform:^id(id value) {
	//				if ([bSelf.currentView isEqual:value])	return value;				 }];
//	}]		_selectedViewControllerIndex 	= selectedViewControllerIndex;
//	NSView *newView 					= (NSView*)[_viewControllers[_selectedViewControllerIndex] view];

//	if (_currentView)					[_currentView removeFromSuperview];
//	newView.frame 				 		= _containerView.bounds;
//	newView.autoresizingMask 		= NSViewWidthSizable|NSViewHeightSizable;
//	[_containerView addSubview:self.currentView = newView];


//- (TBViewController*)selectedViewController { return _viewControllers[self.selectedViewControllerIndex]; }

//- (void)setSelectedViewControllerIndex:(NSUInteger)selectedViewControllerIndex {

//	_selectedViewControllerIndex 	= selectedViewControllerIndex;
//	NSView *newView 					= (NSView*)[_viewControllers[_selectedViewControllerIndex] view];
//	if (_currentView == newView)	return;
//	if (_currentView)					[_currentView removeFromSuperview];
//	newView.frame 				 		= _containerView.bounds;
//	newView.autoresizingMask 		= NSViewWidthSizable|NSViewHeightSizable;
//	[_containerView addSubview:self.currentView = newView];
//	if ([_currentView respondsToSelector:@selector(setAceView:)]) {
//		XX([_currentView vFK:@"controller"]);
//		XX(_currentView.superview.subviews);
//		if (!_aceView) self.aceView = (AZACEView*)[[self.window.contentView subviews][0]firstSubviewOfKind:AZACEView.class];
//		XX(@"Setting Aceview..."); XX(self.aceView);
//		[(id)_currentView setAceView:self.aceView];
//	}
//}

//- (void)setViewControllers:(NSA*)viewControllers {
//	_viewControllers 				= viewControllers;
//	_tabView.titles 				= [_viewControllers valueForKey:@"title"];
//	_tabView.selectedIndex 		= _selectedViewControllerIndex;
//}

//- (IBAction)switchToPosts:		(id)x { _tabView.selectedIndex = 0; }
//- (IBAction)switchToTemplates:(id)x { _tabView.selectedIndex = 1; }
//- (IBAction)switchToSources:	(id)x { _tabView.selectedIndex = 2; }

//	self.aceView.showInvisibles 					= YES;
//	self.aceView.delegate							= self;
//	self.aceView.string = NSS.dicksonBible;

//	[AZNOTCENTER addObserverForKeyPaths:@[AZNewSourceSelectedNotification] task:^(id obj, NSS *kp) {
//		objswitch(kp)
//		objcase(AZNewSourceSelectedNotification)
//			XX(kp); XX(obj);
//		defaultcase AZLOGCMD;
//		endswitch
//	}];	
//	[_vSplitD setCanCollapse:NO subviewAtIndex:1];
//	[_hSPlitD setCanCollapse:NO subviewAtIndex:0];
//	[_vSplitD setMinSize:100 forSubviewAtIndex:1];

//@property (nonatomic,assign) IBOutlet NSLayoutConstraint * containerViewBottomConstraint;
