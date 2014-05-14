//- (void) viewDidLoad 	{ }
//- (void) loadView			{	[super loadView];	} //[super viewDidLoad];	}

#import "AZWebPreviewViewController.h"
#import "TBViewController.h"

@implementation TBAppDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSAPP*)sender { return NO;  }

- (void) applicationDidFinishLaunching:(NSNotification *)notification {

			_wc = AZWelcomeWindowController.new;
		[_wc.window makeKeyAndOrderFront:nil];
}
@end


@implementation TBViewController

-   (id) init 				{ return self = [super initWithNibName:self.defaultNibName bundle:NSBundle.mainBundle]; }
- (NSS*) defaultNibName { return self.className; }
@end


@implementation NSView (FakeAce)
- (ACEView*)aceView 	{  return self.window.aceView; } @end

@implementation NSWindow (FakeAce)
- (ACEView*) aceView 								{ 	NSView *contentV = self.contentView;

	id __block (^find_recursor)(NSV*);								// first define the recursor
	id         (^find_)			(NSV*) = ^id(NSV*topView){ 	// then define the block.

		if ([topView ISKINDA:ACEView.class]) return topView;	__block ACEView* ace = nil;
		[topView.subviews enumerateObjectsUsingBlock:^(NSV* subV, NSUI idx, BOOL *stop) {
			if 	  ( [subV ISKINDA: ACEView.class] ) ace 	= (id)subV, *stop = YES;
			else if ( ( ace = find_recursor(subV) ) ) 						*stop = YES;
		}];
		return ace;
	};	__block ACEView* found = nil;	find_recursor = find_; // initialize the alias	
	// starts the block
	[contentV.subviews enumerateObjectsUsingBlock:^(id obj, NSUI idx, BOOL *stop) { if ((found = find_(obj))) *stop = YES; }];
	return found;
}
-  (NSView*) subviewWithClass:(Class)klass 	{

	id __block (^find_recursor)(NSV*);								// first define the recursor
	id         (^find_)			(NSV*) = ^id(NSV*topView){ 	// then define the block.

		if ([topView ISKINDA:klass]) return topView;
		__block id foundView = nil;
		[topView.subviews enumerateObjectsUsingBlock:^(NSV* subV, NSUI idx, BOOL *stop) {
			if 	  ( [subV ISKINDA:klass] ) foundView = (id)subV, *stop = YES;
			else if ( ( foundView = find_recursor(subV) ) ) 		 *stop = YES;
		}];
		return foundView;
	};	
	__block id found = nil;	find_recursor = find_; // initialize the alias
	
	return find_(self.contentView);
}

@end
//subviews enumerateObjectsUsingBlock:^(id obj, NSUI idx, BOOL *stop) {
//		if ((found = find_(obj))) *stop = YES; // starts the block
//	}];
//	return found;
//		id(^__block recursive)(NSV*) = ^id(NSV*v){  
//		[v.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//			if (![obj ISKINDA:AZACEView.class]) return ace = obj, *stop = YES;
//			else [sum addObject:obj]; else [sum addObjectsFromArray:[obj sublayersRecursive]];
//			return sum;
//	}];
//SYNTHESIZE_ASC_OBJ_ASSIGN(controller, setController);
//SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(aceView, setAceView,^AZAceView*{ return [self associatedValueForKey:@"aceView"] ?: self.controller.aceView; },
//
//	^(id _self, AZAceView*v){ [_self setAssociatedValue:v forKey:@"aceView" policy:OBJC_ASSOCIATION_ASSIGN];
//	});
//
//- (TBViewController*)controller { return [self associatedValueForKey:NSStringFromSelector(_cmd)]; }
//- (void) setController:(TBViewController*)controller  {
//	[self setAssociatedValue:controller forKey:NSStringFromSelector(@selector(controller)) policy:OBJC_ASSOCIATION_ASSIGN];
//}
//		AZBlockSelf(bSelf);
//		XX([self.view vFK:@"controller"]);		
//	XX(((id<TBViewProtocol>)self.view).controller);

