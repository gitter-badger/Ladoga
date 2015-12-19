//
//  LDHTTPServerTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 14.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Ladoga.h"
#import "LDTestServer.h"
#import "LDHTTPRequestHandler.h"
#import <netinet/in.h>
#include <arpa/inet.h>


@interface LDHTTPServerTest : XCTestCase
@end


@implementation LDHTTPServerTest

- (void)testInitialization {
    LDHTTPServer *server = [[LDHTTPServer alloc] initWithAddress:@"127.0.0.1"
                                                         andPort:55310];
    XCTAssertNotNil(server);
}

- (void)testNotImplementedResponse {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55311;
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    LDHTTPServer *httpServer = [[LDHTTPServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
            request.HTTPMethod = @"UNKNOWN";
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(response);
                XCTAssertEqual([(NSHTTPURLResponse *)response statusCode], LD_HTTP_RESPONSE_CODE_NOT_IMPLEMENTED);
                
                [requestExpectation fulfill];
            }] resume];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [httpServer stop];
    }];
}

- (void)testNotFoundResponse {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55312;
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    LDHTTPServer *httpServer = [[LDHTTPServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/nopage.html", TEST_HOST, @(TEST_PORT)]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
            request.HTTPMethod = @"GET";
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(response);
                XCTAssertEqual([(NSHTTPURLResponse *)response statusCode], LD_HTTP_RESPONSE_CODE_NOT_FOUND);
                
                [requestExpectation fulfill];
            }] resume];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [httpServer stop];
    }];
}

- (void)testNotAllowedResponse {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55313;
    
    LDTestServer *testHandler = [[LDTestServer alloc] init];
    
    LDHTTPServer *httpServer = [[LDHTTPServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    
    LDHTTPRequestHandler *requestHandler = [[LDHTTPRequestHandler alloc] initWithHandler:testHandler
                                                                                selector:@selector(indexPage:)
                                                                                 methods:@[ @(LDHTTPMethodGET) ]];
    [httpServer addRequestHandler:requestHandler forPath:@"/index.html"];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
            request.HTTPMethod = @"HEAD";
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(response);
                XCTAssertEqual([(NSHTTPURLResponse *)response statusCode], LD_HTTP_RESPONSE_CODE_METHOD_NOT_ALLOWED);
                
                [requestExpectation fulfill];
            }] resume];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [httpServer stop];
    }];
}

- (void)testNoResponseFromHandler {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55314;
    
    LDTestServer *testHandler = [[LDTestServer alloc] init];
    
    LDHTTPServer *httpServer = [[LDHTTPServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    
    LDHTTPRequestHandler *requestHandler = [[LDHTTPRequestHandler alloc] initWithHandler:testHandler
                                                                                selector:@selector(handleRequest:)
                                                                                 methods:@[ @(LDHTTPMethodGET) ]];
    [httpServer addRequestHandler:requestHandler forPath:@"/index.html"];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
            request.HTTPMethod = @"GET";
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(response);
                XCTAssertEqual([(NSHTTPURLResponse *)response statusCode], LD_HTTP_RESPONSE_CODE_INTERNAL_SERVER_ERROR);
                
                [requestExpectation fulfill];
            }] resume];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [httpServer stop];
    }];
}

- (void)testSuccessResponse {
    NSString * const TEST_HOST = @"127.0.0.1";
    const NSInteger TEST_PORT = 55315;
    
    LDTestServer *testHandler = [[LDTestServer alloc] init];
    
    LDHTTPServer *httpServer = [[LDHTTPServer alloc] initWithAddress:TEST_HOST
                                                             andPort:TEST_PORT];
    
    LDHTTPRequestHandler *requestHandler = [[LDHTTPRequestHandler alloc] initWithHandler:testHandler
                                                                                selector:@selector(indexPage:)
                                                                                 methods:@[ @(LDHTTPMethodGET) ]];
    [httpServer addRequestHandler:requestHandler forPath:@"/index.html"];
    [httpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"connection accepted"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.html", TEST_HOST, @(TEST_PORT)]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
            request.HTTPMethod = @"GET";
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                XCTAssertNil(error);
                XCTAssertNotNil(response);
                XCTAssertEqual([(NSHTTPURLResponse *)response statusCode], LD_HTTP_RESPONSE_CODE_OK);
                
                NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                XCTAssertEqualObjects(responseBody, @"that's ok");
                
                [requestExpectation fulfill];
            }] resume];
        });
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [httpServer stop];
    }];
}

@end
