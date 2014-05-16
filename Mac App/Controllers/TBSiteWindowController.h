
#import <WebKit/WebKit.h>
#import <ACEView/ACEView.h>
#import "AZWebPreviewViewController.h"
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

@interface 		TBSiteWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet 				           NSView * accessoryView, * containerView, * currentView;
@property (weak) IBOutlet 				  		 	  NSMenu * actionMenu;
@property (weak) IBOutlet 			  			  TBTabView * tabView;

@property (weak) IBOutlet							 ACEView * aceView;
@property (weak) IBOutlet 					 AGNSSplitView * leftRight, * topBottom;
@property (weak) IBOutlet 	AZWebPreviewViewController * webPreviewController;

@property			           TBAddPostSheetController * addPostSheetController;
@property                   TBSettingsSheetController * settingsSheetController;
@property                    TBPublishSheetController * publishSheetController;
@property           				 TBStatusViewController * statusViewController;

@property  (readonly)						TBSiteDocument * siteDoc;
@property    (strong)					  				  NSA * viewControllers;
@property  (readonly)	 				 TBViewController * selectedViewController;
@property (nonatomic)    			 				    NSUI   selectedViewControllerIndex;


-     (void) toggleStatusView;

- (IBAction) showAddPostSheet: (id)x;

- (IBAction) showActionMenu:	 (id)x;
- (IBAction) preview:			 (id)x;
- (IBAction) publish:			 (id)x;
- (IBAction) showSettingsSheet:(id)x;

@end

//- (IBAction) switchToPosts:    (id)x;
//- (IBAction) switchToTemplates:(id)x;
//- (IBAction) switchToSources:  (id)x;
//,TBTabViewDelegate>//ACEViewDelegate>
