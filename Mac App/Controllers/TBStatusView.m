//
//  TBStatusView.m
//  Tribo
//
//  Created by Carter Allen on 3/15/12.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//

#import "TBStatusView.h"
@import AtoZ;

@interface TBStatusView ()
@property (nonatomic) NSColor *aquaTopColor, 		*aquaBottomColor, 	*aquaBorderColor, 
										*aquaHighlightColor, *graphiteTopColor,	*graphiteBottomColor, 
										*graphiteBorderColor,*graphiteHighlightColor;
@property (nonatomic, assign) IBOutlet NSTextField *titleField;
@property (nonatomic, strong) NSA*observers;
@end

@implementation TBStatusView

- (void)awakeFromNib {
//	void (^needsDisplayBlock)(NSNotification *note) = ^(NSNotification *note) {
//		[self setNeedsDisplay:YES];
//	};
//	self.observers = @[
//		[AZNOTCENTER addObserver: forKeyPaths:<#(id<NSFastEnumeration>)#>
//		[AZNOTCENTER addObserverForName:NSControlTintDidChangeNotification object:NSApp queue:NSOQ.mainQueue usingBlock:needsDisplayBlock],
//		[AZNOTCENTER addObserverForName:NSWindowDidResignKeyNotification object:self.window queue:NSOQ.mainQueue usingBlock:needsDisplayBlock],
//		[AZNOTCENTER addObserverForName:NSWindowDidBecomeKeyNotification object:self.window queue:NSOQ.mainQueue usingBlock:needsDisplayBlock]
//	];
	NSRect titleFrame = self.titleField.frame;
	titleFrame.size.height += 2.0;
	titleFrame.origin.y -= 2.0;
	self.titleField.frame = titleFrame;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSColor *topColor 		= self.aquaTopColor;
	NSColor *bottomColor 	= self.aquaBottomColor;
	NSColor *borderColor 	= self.aquaBorderColor;
	NSColor *highlightColor = self.aquaHighlightColor;
	if (NSColor.currentControlTint == NSGraphiteControlTint) {
		topColor 		= self.graphiteTopColor;
		bottomColor 	= self.graphiteBottomColor;
		borderColor		= self.graphiteBorderColor;
		highlightColor = self.graphiteHighlightColor;
	}
	if (!self.window.isKeyWindow) {
		CGFloat level = 0.3;
		topColor = [topColor highlightWithLevel:level];
		bottomColor = [bottomColor highlightWithLevel:level];
		borderColor = [borderColor highlightWithLevel:level];
		highlightColor = [highlightColor highlightWithLevel:level];
	}
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:bottomColor];
	[gradient drawInRect:self.bounds angle:270.0];
	[borderColor set];
	NSRect borderRect = NSMakeRect(0.0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0);
	NSRectFill(borderRect);
	[highlightColor set];
	NSRect highlightRect = NSMakeRect(0.0, self.bounds.size.height - 2.0, self.bounds.size.width, 1.0);
	NSRectFill(highlightRect);
}

//- (void)dealloc {
//	for (id observer in _observers) [AZNOTCENTER removeObserver:observer];
//}

@end
