
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class WebViewDelegate; @interface ContentView : NSView

@property (assign) IBOutlet WebView* webView;
@property (strong) WebViewDelegate* delegate;

- (void) triggerEvent:(NSString*)type;


@end
