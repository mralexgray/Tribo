//
//  Notice.m
//  MacGap
//
//  Created by Christian Sullivan on 7/26/12.
//  Copyright (c) 2012 Twitter. All rights reserved.
//

#import "Notice.h"

@implementation Notice

- (void) notify:(NSDictionary*)message {
	NSUserNotification *notification = NSUserNotification.new;
	[notification setTitle:				[message valueForKey:@"title"]];
	[notification setInformativeText:	[message valueForKey:@"content"]];
	[notification setDeliveryDate:		[NSDate dateWithTimeInterval:0 sinceDate:NSDate.date]];
	[notification setSoundName:			NSUserNotificationDefaultSoundName];
	[NSUserNotificationCenter.defaultUserNotificationCenter scheduleNotification:notification];
}

#pragma mark WebScripting Protocol

+ (BOOL) isSelectorExcludedFromWebScript:(SEL)selector 	{ return selector != @selector(notify:); 							}

+ (NSString*) webScriptNameForSelector:(SEL)selector		{ return selector == @selector(notify:) ? @"notify" : nil; 	}

+ (BOOL) isKeyExcludedFromWebScript:(const char*)name		{ return YES; 																}
// right now exclude all properties (eg keys)
@end
