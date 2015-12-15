//
//  LDHTTPServerTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 14.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Ladoga.h"
#import <netinet/in.h>
#include <arpa/inet.h>


typedef LDHTTPResponse* (^ConnectionHandler) (LDHTTPRequest*);


@interface TestHTTPServerDelegate : NSObject <LDHttpServerDelegate>
@property (nonatomic, strong, readwrite) ConnectionHandler handler;
@end

@implementation TestHTTPServerDelegate
- (LDHTTPResponse *)processRequest:(LDHTTPRequest *)request {
    if (self.handler) {
        return self.handler(request);
    }
    return nil;
}
@end


@interface LDHTTPServerTest : XCTestCase
@end


@implementation LDHTTPServerTest

- (void)testInitialization {
    LDHttpServer *server = [[LDHttpServer alloc] initWithAddress:@"127.0.0.1"
                                                         andPort:55310];
    XCTAssertNotNil(server);
}

- (void)testConnectionWithDelegateAccepting {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55311;
    
    XCTestExpectation *connectionWithDelegateExpectation = [self expectationWithDescription:@"connection with delegate accepted"];
    
    TestHTTPServerDelegate *testServer = [[TestHTTPServerDelegate alloc] init];
    testServer.handler = ^LDHTTPResponse*(LDHTTPRequest *request) {
        [connectionWithDelegateExpectation fulfill];
        return nil;
    };
    
    LDHttpServer *httpServer = [[LDHttpServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    httpServer.httpServerDelegate = testServer;
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            NSData *data = [NSData dataWithContentsOfURL:requestURL];
            XCTAssertNotNil(data);
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        [httpServer stop];
    }];
}

- (void)testRequestHandling {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55312;
    NSString * const TEST_BODY = @"TEST_BODY";
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    TestHTTPServerDelegate *testServer = [[TestHTTPServerDelegate alloc] init];
    testServer.handler = ^LDHTTPResponse*(LDHTTPRequest *request) {
        LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
        response.code = 200;
        response.body = TEST_BODY;
        return response;
    };
    
    LDHttpServer *httpServer = [[LDHttpServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    httpServer.httpServerDelegate = testServer;
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            
            NSError *error;
            NSString *responseString = [NSString stringWithContentsOfURL:requestURL
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
            XCTAssertNil(error);
            XCTAssertNotNil(responseString);
            XCTAssertEqualObjects(responseString, TEST_BODY);
            
            [requestExpectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        [httpServer stop];
    }];
}

- (void)testNoDelegate {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55313;
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    LDHttpServer *httpServer = [[LDHttpServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            
            NSError *error;
            NSString *responseString = [NSString stringWithContentsOfURL:requestURL
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
            XCTAssertNil(error);
            XCTAssertNotNil(responseString);
            XCTAssertEqualObjects(responseString, @"Internal server error");
            
            [requestExpectation fulfill];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        [httpServer stop];
    }];
}

@end
