//
//  AZWelcomeWindowController.m
//  Tribo
//
//  Created by Alex Gray on 9/26/13.
//  Copyright (c) 2013 Opt-6 Products, LLC. All rights reserved.
//

#import "AZWelcomeWindowController.h"

@interface AZWelcomeWindowController ()

@end

@implementation AZWelcomeWindowController

- (id)initWithWindow:(NSWindow*)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
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
