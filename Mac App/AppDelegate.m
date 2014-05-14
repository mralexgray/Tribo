//
//  AppDelegate.m
//  MacGap
//
//  Created by Alex MacCaw on 08/01/2012.
//  Copyright (c) 2012 Twitter. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

-(BOOL)applicationShouldHandleReopen:(NSApplication*)app hasVisibleWindows:(BOOL)vw{

	return !vw ? [self.windowController.window makeKeyAndOrderFront: nil], YES : YES;
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {

	[self.windowController = [WindowController.alloc initWithURL:@"http://mrgray.com"
																		 andFrame:NSMakeRect(0, 0, 500, 600)]
																	  showWindow:NSApplication.sharedApplication.delegate];

	_windowController.contentView.webView.preferences.standardFontFamily = @"UbuntuMono-Bold, sans-serif";
	_windowController.contentView.webView.preferences.defaultFontSize = 8;
	_windowController.contentView.webView.preferences.minimumFontSize =
	_windowController.contentView.webView.alphaValue =
	_windowController.contentView.		  alphaValue = 1.0;               [_windowController showWindow:self];
}

@end

