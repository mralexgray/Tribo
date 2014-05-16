
#define HEIGHT size.height
#define WIDTH  size.width
#define OX  origin.x
#define OY  origin.y

#import "TBTabView.h"
#import <QuartzCore/QuartzCore.h>

@implementation 								TBTab

-    (id) initWithFrame:(NSRect)f 		{	if (!(self = [super initWithFrame:f])) return nil;

	self.alignment 					= NSCenterTextAlignment;
	self.editable 						= NO;
	self.drawsBackground 			= NO;
	self.textColor 					= BLACK;
	[self.cell setBordered		   : NO];
	[self.cell setBackgroundStyle : NSBackgroundStyleRaised];
	[self.cell setFont				: @"UbuntuMono"];//AtoZ.controlFont];
  return self;
}
-  (void) drawRect:  	(NSRect)dRect 	{ 
	
	NSRectFillWithColor(dRect,self.clicked ? self.backgroundColor : [self.backgroundColor colorWithBrightnessMultiplier:3]);	
	[super drawRect:dRect]; 
}
-  (void) mouseDown:    (NSEvent*)e 	{ [((TBTabView*)self.superview) tabReceivedMouseDown:self]; }
+ (Class) cellClass 							{ return [TBVerticallyCenteredTextFieldCell class];	}
@end

@implementation 										TBVerticallyCenteredTextFieldCell
-  (NSR) titleRectForBounds:	 (NSR)r 			{	NSRect titFrame = [super titleRectForBounds:r];
	titFrame.OY = r.OY + (r.HEIGHT - self.attributedStringValue.HEIGHT) / 2.0;				return titFrame;
}
- (void) drawInteriorWithFrame:(NSRect)cF 
								inView:(NSView*)cV 	{ [super drawInteriorWithFrame:[self titleRectForBounds:cF] inView:cV]; }
@end

@implementation 										TBTabView
-   (void) setTitles:(NSA*)titles 				{	CGF  tabWidth 	= ceil(self.width/titles.count);

	self.subviews 	= [titles nmap:^id(NSS*title, NSUI idx) {
	
		TBTab *tab 				= [TBTab.alloc initWithFrame:NSMakeRect(idx * tabWidth, 0, tabWidth, self.height)];
		tab.target 		 		= self;
		tab.stringValue 		= title;
		tab.backgroundColor  = @[RED, ORANGE, YELLOW, GREEN, BLUE, GRAY4][idx];
		tab.autoresizingMask = !idx 							? NSViewWidthSizable|NSViewMaxXMargin
									: idx == titles.count - 1 	? NSViewWidthSizable|NSViewMinXMargin
																		: NSViewWidthSizable|NSViewMinXMargin|NSViewMaxXMargin;
		return tab;
	}];
	[self setNeedsDisplay:YES];
}
- (TBTab*) selectedTab 								{ //  filterOne:^BOOL(TBTab*t){ return t.clicked; }]
	NSLog(@"self.subviews: %@", self.subviews);
	return [self.subviews firstObjectWithValue:@YES forKeyPath:@"clicked"] ?: ^{ [self.subviews[0] setClicked:YES]; return self.subviews[0]; }();
}
-   (void) tabReceivedMouseDown:(TBTab*)tab 	{

	[self.subviews setValue:@NO forKeyPath:@"clicked"];
	tab.clicked = YES;
	[self setNeedsDisplay:YES];
	if (self.tabReceivedMouseDown) self.tabReceivedMouseDown(self,tab); //[self.delegate tabView:self didSelectIndex:[self.subviews indexOfObject:tab]];
}
- (void)drawRect:(NSRect)rect {	CGF  numberOfTabs = self.subviews.count; if (!numberOfTabs) return;


	// Fill everything with the base white gradient.
	[[NSGradient gradientFrom:WHITE to:GRAY9]drawInRect:self.bounds angle:270];

	NSRectFillWithColor(NSMakeRect(0, 0, self.width, 1),GRAY7);  //(topBorderRect);

	
	// Pre-calculate rectangles for each tab, because the frames are unreliably rounded

	CGF      tabWidth = floor(self.width / numberOfTabs);
	CGF     remainder = self.width - (tabWidth * numberOfTabs);
	id selected = [self selectedTab];

	[self.subviews eachWithIndex:^(id obj, NSInteger idx) {
		
		CGRect tabFrame = { 	.origin 	= { .x = (idx * tabWidth),  .y =  0 },
									.size 	= { .width = tabWidth, .height = rect.size.height }};
									
		tabFrame.size.width += idx == (NSI)(numberOfTabs - 1) ? remainder : 0;
		if (!idx && idx != numberOfTabs)
			 NSRectFillWithColor(NSMakeRect(tabFrame.origin.x,0,1,rect.size.height), GRAY2);
			 // 			NSRect lineRect = 
		// Draw a darker gradient over the selected tab.
		[obj isEqual: selected] ? 
		[[NSGradient gradientFrom:GRAY9 to:GRAY8] drawInRect:[selected frame] angle:270] : nil;

	}];
	
	// Draw an inverted gradient over the clicked tab, if there is one.
	
//	NSGradient *clickedGradient = nil;
//	if ([self.tabs indexOfObject:_clickedTab] == self.selectedIndex)
//			clickedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.85 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.89 alpha:1.0]];
//		else
//			clickedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.94 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.98 alpha:1.0]];
//		[clickedGradient drawInRect:tabFrames[[self.subviews indexOfObject:_clickedTab]] angle:270.0];
//	}
	
	// Draw the bottom border and inset line.


	
	// Draw border lines and titles for each tab.
//	for (NSUInteger index = 0; index < [self.subviews count; index++) {
//		if (index != (self.subviews.count) && index != 0) {
//			NSRect lineRect = NSMakeRect(tabFrames[index].origin.x, 0.0, 1.0, self.frame.size.height);
//			NSRectFill(lineRect);
//		}
//	}
	
}

@end
//	_clickedTab = tab;
//- (void)tabReceivedMouseUp:(TBTab*)tab {
//	_clickedTab = nil;
//	NSUInteger index = [self.subviews indexOfObject:tab];
//	self.selectedIndex = index;
//}

//	((TBTabView*)self.superview).tabReceivedMouseDown(((TBTabView*)self.superview), self); }
//- (void)mouseUp:(NSEvent*)theEvent {
//	TBTabView *tabView = (TBTabView*)self.superview;
//	[tabView tabReceivedMouseUp:self];
//@property (nonatomic) NSMA *tabs;
//- (void) tabReceivedMouseUp:  (TBTab*)tab;

//- (void)setSelectedIndex:(NSUInteger)selectedIndex {
//	_selectedIndex = selectedIndex;
//	[self setNeedsDisplay:YES];
//	[self.delegate tabView:self didSelectIndex:selectedIndex];
//}

