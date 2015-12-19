//
//  LDTestServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDHTTPResponse.h"
#import "LDHTTPRequest.h"
#import "LDHTTPRequestHandler.h"


@interface LDTestServer : NSObject

- (LDHTTPResponse *)handleRequest:(LDHTTPRequest *)request;
- (LDHTTPResponse *)indexPage:(LDHTTPRequest *)request;
@end
