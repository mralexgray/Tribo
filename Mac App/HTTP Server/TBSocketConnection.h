//
//  TBSocketConnection.h
//  Tribo
//
//  Created by Carter Allen on 2/24/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

@import CocoaHTTPServer.HTTPConnection;
#import "TBWebSocket.h"


@interface TBSocketConnection : HTTPConnection
@property (readonly) TBWebSocket *socket;
@end
