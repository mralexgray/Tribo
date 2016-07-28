//
//  AZWelcomeWindowController.m
//  Tribo
//
//  Created by Alex Gray on 9/26/13.
//  Copyright (c) 2013 Opt-6 Products, LLC. All rights reserved.
//

#import "AZWelcomeWindowController.h"
@import AtoZ;

@interface AZWelcomeWindowController ()

@end

@implementation AZWelcomeWindowController

- (id)init	{
//  self = super.init;
//  self.window =
  self = [super initWithWindow:[NSW windowWithFrame:AZCenteredRect(AZSizeFromDim(200), AZScreenFrameUnderMenu()) mask:2]];
//AZBORDLESSWINDOWINIT(
		[[(NSView*)self.window.contentView layer] setBackgroundColor: cgBLUE];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	 NSW* w = self.window;
	 NSR r = AZScreenFrameUnderMenu();
	 r.origin.y = NSMaxY(r) - 100;
	 r.size.height = 100;
	[w setFrame:r display:YES];
	w.bgC = RED;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
