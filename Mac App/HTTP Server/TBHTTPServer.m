//
//  TBHTTPServer.m
//  Tribo
//
//  Created by Carter Allen on 2/24/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBHTTPServer.h"
#import "TBSocketConnection.h"
#import "TBWebSocket.h"

@implementation TBHTTPServer

- (id)init {	self = super.init; self.connectionClass = TBSocketConnection.class; return self; }

- (void)refreshPages {

//	[webSockets makeObjectsPerformSelector:@selector(sendMessage:)
//										withObject:@"{ \"command\": \"reload\", \"path\": \"/\", \"liveCSS\": true }"];
}
@end
