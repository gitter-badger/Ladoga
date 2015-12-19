//
//  LDHTTPRequestHandlerTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LDTestServer.h"
#import "LDHTTPResponse.h"
#import "LDHTTPRequest.h"
#import "LDHTTPRequestHandler.h"


@interface LDHTTPRequestHandlerTest : XCTestCase
@end


@implementation LDHTTPRequestHandlerTest

- (void)testInitialization {
    LDTestServer *server = [[LDTestServer alloc] init];
    
    NSArray *methods = @[ @(LDHTTPMethodHEAD) ];
    LDHTTPRequestHandler *handler = [[LDHTTPRequestHandler alloc] initWithHandler:server
                                                                         selector:@selector(handleRequest:)
                                                                          methods:methods];
    
    XCTAssertNotNil(handler);
    XCTAssertEqualObjects(handler.handler, server);
    XCTAssertEqual(handler.selector, @selector(handleRequest:));
    XCTAssertEqual(handler.methods.count, 1);
    XCTAssertEqualObjects([handler.methods firstObject], [methods firstObject]);
}

@end
