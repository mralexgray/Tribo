//
//  TBSiteWindowController.h
//  Tribo
//
//  Created by Carter Allen on 10/21/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//
#import <WebKit/WebKit.h>

@class 					TBViewController , 
				 TBAddPostSheetController ;
@interface 		TBSiteWindowController : NSWindowController <NSWindowDelegate>
@property (nonatomic) 			NSA* viewControllers;
@property (readonly) TBViewController * selectedViewController;
@property (nonatomic)      NSUInteger   selectedViewControllerIndex;

- (IBAction) switchToPosts:    (id)x;
- (IBAction) switchToTemplates:(id)x;
- (IBAction) switchToSources:  (id)x;

- (IBAction) showAddPostSheet: (id)x;

- (IBAction) showActionMenu:	 (id)x;
- (IBAction) preview:			 (id)x;
- (IBAction) publish:			 (id)x;
- (IBAction) showSettingsSheet:(id)x;

@end
