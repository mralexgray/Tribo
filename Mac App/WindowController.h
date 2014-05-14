

#import "ContentView.h"

@interface WindowController : NSWindowController

- (id) initWithURL:(NSS*)url 
			 andFrame:(NSR)frame;
			 
- (id) initWithRequest:(NSURLREQ*)request;

@property 					 NSURL * url;
@property IBOutlet ContentView * contentView;

@end
