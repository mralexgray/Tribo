#import "App.h"

#import "JSEventHelper.h"

@implementation App

@synthesize webView;

-   (id) initWithWebView:(WebView*)view { return (self = super.init) ? webView = view,
        [AZWORKSPACENC addObserver: self  selector: @selector(receiveSleepNotification:) 
		  													 name: NSWorkspaceWillSleepNotification object: NULL],
        [AZWORKSPACENC addObserver: self  selector: @selector(receiveWakeNotification:) 
		                                        name: NSWorkspaceDidWakeNotification object: NULL], self : nil;
}

- (void) terminate 			{  [NSApp terminate:nil];										}
- (void) activate 			{	[NSApp activateIgnoringOtherApps:YES];					}
- (void) hide 					{  [NSApp hide:nil];												}
- (void) unhide 				{  [NSApp unhide:nil];											}
- (void) beep 					{  NSBeep();														}
- (void) open:	 (NSS*)url 	{	[AZWORKSPACE openURL:[NSURL URLWithString:url]];	}
- (void) launch:(NSS*)name {  [AZWORKSPACE launchApplication:name];					}

- (void)receiveSleepNotification:(NSNotification*)note	{
    [JSEventHelper triggerEvent:@"sleep" forWebView:self.webView];
}
- (void) receiveWakeNotification:(NSNotification*)note	{
    [JSEventHelper triggerEvent:@"wake" forWebView:self.webView];
}

+ (NSString*) webScriptNameForSelector: 		    (SEL)sel	{ 
	
	return sel == @selector(open:) ? @"open" : sel == @selector(launch:) ? @"launch" : nil;
}
+      (BOOL) isSelectorExcludedFromWebScript:   (SEL)sel  	{	return NO;	}
+      (BOOL) isKeyExcludedFromWebScript:(const char*)name	{
	return YES;
}

@end
