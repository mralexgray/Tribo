
//@property (nonatomic) NSMA *tabs;
//- (void) tabReceivedMouseUp:  (TBTab*)tab;


#import "TBTabView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TBTab

- (id)initWithFrame:(NSRect)frame {	if (!(self = [super initWithFrame:frame])) return nil;

	self.alignment = NSCenterTextAlignment;
	self.editable = NO;
	self.drawsBackground = NO;
	self.textColor = [NSColor controlTextColor];
	[self.cell setBordered:NO];
	[self.cell setBackgroundStyle:NSBackgroundStyleRaised];
	[self.cell setFont:AtoZ.controlFont];	// boldSystemFontOfSize:11.0]];
	return self;
}
- (void) drawRect:(NSRect)dirtyRect {

	if (self.clicked)	NSRectFillWithColor(dirtyRect, [RED alpha:.8]);
	[super drawRect:dirtyRect];
	
}
+ (Class)cellClass {	return [TBVerticallyCenteredTextFieldCell class];	}

- (void)mouseDown:(NSEvent*)theEvent {

//	((TBTabView*)self.superview).tabReceivedMouseDown(((TBTabView*)self.superview), self); }
	[((TBTabView*)self.superview) tabReceivedMouseDown:self];
//- (void)mouseUp:(NSEvent*)theEvent {
//	TBTabView *tabView = (TBTabView*)self.superview;
//	[tabView tabReceivedMouseUp:self];
}

@end

@implementation TBVerticallyCenteredTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)theRect {	NSRect titleFrame = [super titleRectForBounds:theRect];
	titleFrame.origin.y = theRect.origin.y + (theRect.size.height - self.attributedStringValue.size.height) / 2.0;
	return titleFrame;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	[super drawInteriorWithFrame:[self titleRectForBounds:cellFrame] inView:controlView];
}

@end

@implementation TBTabView

- (void)setTitles:(NSA*)titles {

//	self.tabs 		= NSMA.new;
	CGF  tabWidth 	= ceil(self.width/titles.count),
		  tabHeight = self.height;
	self.subviews 	= [titles nmap:^id(NSS*title, NSUI idx) {
		TBTab *tab 	= [TBTab.alloc initWithFrame:NSMakeRect(idx * tabWidth, 0, tabWidth, tabHeight)];
		tab.target 		 		= self;
		tab.stringValue 		= title;
		tab.autoresizingMask = 	!idx ? NSViewWidthSizable|NSViewMaxXMargin
									:  idx == titles.count - 1 ? NSViewWidthSizable|NSViewMinXMargin
									:	NSViewWidthSizable|NSViewMinXMargin|NSViewMaxXMargin;
		return tab;
	}];
	[self setNeedsDisplay:YES];
}

//- (void)setSelectedIndex:(NSUInteger)selectedIndex {
//	_selectedIndex = selectedIndex;
//	[self setNeedsDisplay:YES];
//	[self.delegate tabView:self didSelectIndex:selectedIndex];
//}

- (TBTab*) selectedTab { id x = [self.subviews filterOne:^BOOL(TBTab*t){ return t.clicked; }];

	if (!x) {  x = self.subviews[0];  [x setClicked:YES]; } return x;
}

- (void)tabReceivedMouseDown:(TBTab*)tab {


	[self.subviews setValue:@NO forKeyPath:@"clicked"];
	tab.clicked = YES;
	[self setNeedsDisplay:YES];
	if (self.tabReceivedMouseDown) self.tabReceivedMouseDown(self, tab);
	///	[self.delegate tabView:self didSelectIndex:[self.subviews indexOfObject:tab]];
}

//	_clickedTab = tab;
//- (void)tabReceivedMouseUp:(TBTab*)tab {
//	_clickedTab = nil;
//	NSUInteger index = [self.subviews indexOfObject:tab];
//	self.selectedIndex = index;
//}

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

