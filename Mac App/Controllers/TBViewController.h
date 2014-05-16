//
//  TBViewController.h
//  Tribo
//
//  Created by Carter Allen on 10/21/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//
#import <ACEView/ACEView.h>
#import "AZWelcomeWindowController.h"
@import AtoZ;


@interface TBAppDelegate : NSObject <NSApplicationDelegate>
@property AZWelcomeWindowController *wc;
@end


@class 		 					 TBSiteDocument ;
@interface 					  TBViewController : NSVC
@property (nonatomic,weak)  TBSiteDocument * document;
@property (readonly) 					   NSS * defaultNibName;
@property (readonly)					  ACEView * aceView;
@end

@interface   NSWindow (FakeAce)
-     (NSView*) subviewWithClass:(Class)k;
- (ACEView*) aceView;
@end

//-      (void) viewDidLoad;
//@protocol TBViewProtocol <NSObject>
//@concrete 
//@property (weak) TBViewController *controller; 
//@end
