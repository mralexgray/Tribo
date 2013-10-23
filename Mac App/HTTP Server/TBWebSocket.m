//
//  TBWebSocket.m
//  Tribo
//
//  Created by Carter Allen on 2/24/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBWebSocket.h"

@implementation TBWebSocket

- (void)didOpen {
	[self sendMessage:	@" { 	\"command\"		: \"hello\","
								 "		\"protocols\"	: [	\"http://livereload.com/protocols/official-7\","
								 "									\"http://livereload.com/protocols/official-8\","
								 "									\"http://livereload.com/protocols/2.x-origin-version-negotiation\"  ],"
								 "    \"serverName\"	: \"Tribo\" 	}"];
}
- (void)didReceiveMessage:(NSS*)message {	}

- (void)didClose {	}

@end
