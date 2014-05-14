
@interface 										TBTab : NSTextField	
@property BOOL clicked;														@end

@interface TBVerticallyCenteredTextFieldCell : NSTextFieldCell	@end


@interface 								 TBTabView : AZSimpleView
@property (nonatomic) 		   			 NSA * titles;
@property (readonly) 					  TBTab * selectedTab;

@property (copy) void(^tabReceivedMouseDown)(TBTabView*, TBTab*);
- (void) tabReceivedMouseDown:(TBTab*)tab;

@end

//@protocol 					  TBTabViewDelegate ;
//@property (weak) IBOutlet id <TBTabViewDelegate>   delegate;
//@protocol						TBTabViewDelegate   <NSObject>
//- (void)  tabView:(TBTabView*)tabView didSelectIndex:(NSUI)index;
//
//@end
//@interface TBTabView ()	// {	TBTab *_clickedTab;	}
//@property (nonatomic)		NSUI   selectedIndex;   // was public
//@property (nonatomic)		id   selectedTab; // was public
////- (void) tabReceivedMouseDown:(TBTab*)tab;
////@property (readonly) TBTab* selectedTab;
//@end
