//
//  TBViewController.h
//  Tribo
//
//  Created by Carter Allen on 10/21/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//
#import <ACEView/ACEView.h>


@class 		 					 TBSiteDocument ;
@interface 					  TBViewController : NSVC
@property (nonatomic,weak)  TBSiteDocument * document;
@property (readonly) 					   NSS * defaultNibName;

@end

@interface NSWindow (Fake)
-     (NSV*) subviewWithClass:(Class)k;
- (ACEView*) aceView;
@end


//-      (void) viewDidLoad;
//@protocol TBViewProtocol <NSObject>
//@concrete 
//@property (weak) TBViewController *controller; 
//@end
