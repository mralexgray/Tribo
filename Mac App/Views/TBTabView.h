//
//  TBTabView.h
//  Tribo
//
//  Created by Carter Allen on 10/29/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//
@interface TBTab : NSTextField	@property BOOL clicked;			@end
@interface TBVerticallyCenteredTextFieldCell : NSTextFieldCell	@end


@interface 								 TBTabView : NSView
@property (nonatomic) 		   			 NSA * titles;
@property (readonly) 					  TBTab * selectedTab;

@property (copy) void(^tabReceivedMouseDown)(TBTabView*, TBTab*);
- (void) tabReceivedMouseDown:(TBTab*)tab;

//@protocol 					  TBTabViewDelegate ;
//@property (weak) IBOutlet id <TBTabViewDelegate>   delegate;

@end

//@protocol						TBTabViewDelegate   <NSObject>
//- (void)  tabView:(TBTabView*)tabView didSelectIndex:(NSUI)index;
//
//@end




//@interface TBTabView ()	// {	TBTab *_clickedTab;	}

//@property (nonatomic)		NSUI   selectedIndex;   // was public
//@property (nonatomic)		id   selectedTab; // was public

//
////- (void) tabReceivedMouseDown:(TBTab*)tab;
////
////@property (readonly) TBTab* selectedTab;
//@end
