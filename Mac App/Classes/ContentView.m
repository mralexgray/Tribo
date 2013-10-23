
#import "ContentView.h"
#import "WebViewDelegate.h"
#import "AppDelegate.h"

@interface WebPreferences (WebPreferencesPrivate)
- (void)_setLocalStorageDatabasePath:(NSString*)path;
- (void) setLocalStorageEnabled: (BOOL) localStorageEnabled;
- (void) setDatabasesEnabled:(BOOL)databasesEnabled;
- (void) setDeveloperExtrasEnabled:(BOOL)developerExtrasEnabled;
- (void) setWebGLEnabled:(BOOL)webGLEnabled;
- (void) setOfflineWebApplicationCacheEnabled:(BOOL)offlineWebApplicationCacheEnabled;
@end

@implementation ContentView

- (void) awakeFromNib	{

	self.webView.preferences = WebPreferences.standardPreferences;
	    _webView.preferences.offlineWebApplicationCacheEnabled = 
	    _webView.preferences.				  localStorageEnabled  = 
	    _webView.preferences.					  databasesEnabled  = 
		 _webView.preferences.							webGLEnabled  = YES;
		 _webView.preferences.           developerExtrasEnabled = [AZUSERDEFS boolForKey:@"developer"];	
		[_webView.preferences _setLocalStorageDatabasePath:[NSS pathWithComponents:@[@"~/Library/Application Support/".stringByExpandingTildeInPath, 
																											AZAPPBUNDLE.infoDictionary[@"CFBundleName"], @"LocalStorage"]]];

	NSHTTPCookieStorage *cookieStorage 		= NSHTTPCookieStorage.sharedHTTPCookieStorage;
	cookieStorage.cookieAcceptPolicy			= NSHTTPCookieAcceptPolicyAlways;
	_webView.applicationNameForUserAgent 	= @"Dashcat";

	_delegate 								= WebViewDelegate.new;
	_webView.frameLoadDelegate			= self.delegate;
	_webView.UIDelegate					= self.delegate;
	_webView.resourceLoadDelegate		= self.delegate;
	_webView.downloadDelegate			= self.delegate;
	_webView.policyDelegate				= self.delegate;
	_webView.drawsBackground			= NO;
	_webView.shouldCloseWithWindow	= NO;
	_webView.groupName					= @"Dashcat";

}
- (void) windowResized:(NSNOT*)notification	{

	NSW* window 			= (NSW*)notification.object;
	NSSZ size 				= window.frame.size;
	NSLog(@"window width = %f, window height = %f", size.width, size.height);
	bool isFullScreen 	= (window.styleMask & NSFullScreenWindowMask) == NSFullScreenWindowMask;
//	int titleBarHeight 	= isFullScreen ? 0 : [Utils.sharedInstance titleBarHeight:window];

//	[self.webView setFrame:NSMakeRect(0, 0, size.width, size.height - titleBarHeight)];
	[self triggerEvent:@"orientationchange"];
}
- (void) triggerEvent:(NSString*)type	{

	[self.webView stringByEvaluatingJavaScriptFromString:$(@"var e = document.createEvent('Events'); \
													  e.initEvent('%@', true, false); document.dispatchEvent(e);", type)];
}
@end
