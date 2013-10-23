//
//  TBSocketConnection.m
//  Tribo
//
//  Created by Carter Allen on 2/24/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBSocketConnection.h"
#import "TBWebSocket.h"
//#import "HTTPDataResponse.h"

@interface TBSocketConnection () <WebSocketDelegate>
@property WebSocket *socket;
@end

@implementation TBSocketConnection

- (WebSocket*)webSocketForURI:(NSString*)path {

	return [path isEqualToString:@"/livereload"] ? (self.socket = [TBWebSocket.alloc initWithRequest:request socket:asyncSocket])
																: [super webSocketForURI:path];
}

- (NSObject <HTTPResponse>*)httpResponseForMethod:(NSS*)method URI:(NSS*)path {
	
	return [path hasPrefix:@"/livereload.js"]
		?	 [HTTPDataResponse.alloc initWithData:[AZAPPBUNDLE.infoDictionary[@"TBLiveReloadJS"] dataUsingEncoding:NSUTF8StringEncoding]]
		:	 [super httpResponseForMethod:method URI:path];
}

@end
