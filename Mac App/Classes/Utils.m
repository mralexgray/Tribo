#import "Utils.h"

static Utils* sharedInstance = nil;

@implementation Utils

- (CGF) titleBarHeight:(NSWindow*)aWindow
{
    NSRect frame = [aWindow frame];
    NSRect contentRect = [NSWindow contentRectForFrameRect: frame
												 styleMask: NSTitledWindowMask];
	
    return (frame.size.height - contentRect.size.height);
}

- (NSString*) pathForResource:(NSString*)resourcepath	{

    NSA *directoryParts = [resourcepath componentsSeparatedByString:@"/"];
    NSS        *filename = [directoryParts lastObject];

    return [AZAPPBUNDLE pathForResource:filename ofType:@"" 
	 								 inDirectory:$(@"%@/%@", @(kRootFolder), 
								[directoryParts.arrayByRemovingLastObject componentsJoinedByString:@"/"])];//kStartFolder
}

#pragma mark -
#pragma mark Singleton methods

+ (Utils*) sharedInstance	{  @synchronized(self)  { 

	if (sharedInstance == nil){	sharedInstance = [[Utils alloc] init];  }  }    return sharedInstance;
}

+ (id) allocWithZone:(NSZone*)zone {	@synchronized(self) {  // assignment and return on first allocation
        if (sharedInstance == nil) {  return sharedInstance = [super allocWithZone:zone]; }  } return nil; 
}      // on subsequent allocation attempts return nil

- (id) copyWithZone:(NSZone*)zone	{return self;	}

@end
