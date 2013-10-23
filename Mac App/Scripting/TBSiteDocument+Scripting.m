//
//  TBSiteDocument+Scripting.m
//  Tribo
//
//  Created by Carter Allen on 2/7/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBSiteDocument+Scripting.h"
#import "TBSiteWindowController.h"
#import "TBPostsViewController.h"
#import "TBSite.h"
#import "TBHTTPServer.h"

@implementation TBSiteDocument (Scripting)

- (void)startPreviewFromScript:(NSScriptCommand*)command {	if (self.server.isRunning) return;	[command suspendExecution];
 	
	self.postsViewController ?	[self startPreview:^(NSURL *localURL, NSError *error) {
	
		if (error) [command setScriptErrorNumber:(int)error.code], [command setScriptErrorString:error.localizedDescription];
		[command resumeExecutionWithResult:nil];
	}] : nil;
}
- (void)stopPreviewFromScript:(NSScriptCommand*)command {  if (!self.server.isRunning || !self.postsViewController) return;	[self stopPreview]; }

- (TBPostsViewController*)postsViewController { return [[self.windowControllers[0]viewControllers] firstObjectOfClass:TBPostsViewController.class]; }
@end


//	for (TBViewController *viewController in windowController.viewControllers) {
//		if ([viewController class] == [ class]) {
//			postsViewController = (TBPostsViewController*)viewController;
//			continue;
//		}
//	}
//	TBSiteWindowController *windowController	 = (
