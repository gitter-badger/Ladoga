//
//  LDTestServer.m
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDTestServer.h"


@implementation LDTestServer

- (LDHTTPResponse *)handleRequest:(LDHTTPRequest *)request {
    return nil;
}

- (LDHTTPResponse *)indexPage:(LDHTTPRequest *)request {
    LDHTTPResponse *response = [[LDHTTPResponse alloc] initWithCode:LD_HTTP_RESPONSE_CODE_OK];
    response.body = @"that's ok";
    return response;
}

@end
