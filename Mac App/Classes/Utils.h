


#define DEG_EPS 0.001
#define fequal(a,b) (fabs((a) - (b)) < DEG_EPS)
#define fequalzero(a) (fabs(a) < DEG_EPS)

@class LoadingView;
@interface Utils : NSObject 

- (CGF) titleBarHeight:(NSWindow*)aWindow;
- (NSString*) pathForResource:(NSString*)resourcepath;

+ (Utils*) sharedInstance;

@end
