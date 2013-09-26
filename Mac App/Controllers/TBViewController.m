//
//  TBViewController.m
//  Tribo
//
//  Created by Carter Allen on 10/21/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//

#import "TBViewController.h"

@implementation TBViewController

-        (id) init 				{	return self = [super initWithNibName:self.defaultNibName bundle:NSBundle.mainBundle];	}
- (NSString*) defaultNibName 	{ return self.className; }
-      (void) viewDidLoad 		{}
-      (void) loadView 			{	[super loadView];	[self viewDidLoad];	}

@end
