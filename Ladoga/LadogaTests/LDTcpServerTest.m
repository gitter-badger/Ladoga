//
//  LDTcpServerTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Ladoga.h"
#import <netinet/in.h>
#include <arpa/inet.h>


typedef void(^ConnectionHandler)();


@interface TestServer : NSObject <LDTcpServerDelegate>
@property (nonatomic, strong, readwrite) ConnectionHandler handler;
@end

@implementation TestServer
- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle {
    if (self.handler) {
        self.handler();
    }
}
@end


@interface LDTcpServerTest : XCTestCase
@end


@implementation LDTcpServerTest

- (void)testInitialization {
    LDTcpServer *tcpServer = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                          andPort:55300];
    XCTAssertNotNil(tcpServer);
    
    [tcpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTAssertEqualObjects(tcpServer.address, @"127.0.0.1");
    XCTAssertEqual(tcpServer.port, 55300);
    
    [tcpServer stop];
}

- (void)testBinding {
    LDTcpServer *tcpServer = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                          andPort:55300];
    
    [tcpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTAssertEqualObjects(@"127.0.0.1", tcpServer.address);
    XCTAssertEqual(55300, tcpServer.port);
    
    [tcpServer stop];
}

- (void)testDefaultValuesOnBinding {
    LDTcpServer *tcpServer = [[LDTcpServer alloc] initWithAddress:nil
                                                          andPort:0];
    
    [tcpServer startWithRunLoop:CFRunLoopGetMain()];
    
    XCTAssertEqualObjects(@"0.0.0.0", tcpServer.address);
    XCTAssertNotEqual(0, tcpServer.port);
    
    [tcpServer stop];
}

- (void)testRebinding {
    LDTcpServer *tcpServerFirst = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                               andPort:55301];
    LDTcpServer *tcpServerSecond = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                                andPort:55301];
    
    XCTAssertTrue([tcpServerFirst startWithRunLoop:CFRunLoopGetMain()]);
    XCTAssertFalse([tcpServerSecond startWithRunLoop:CFRunLoopGetMain()]);
    
    [tcpServerFirst stop];
    
    XCTAssertTrue([tcpServerSecond startWithRunLoop:CFRunLoopGetMain()]);
    
    [tcpServerSecond stop];
}

- (void)testConnectionDelegate {
    XCTestExpectation *connectionExpectation = [self expectationWithDescription:@"connection accepted"];
    
    TestServer *testServer = [[TestServer alloc] init];
    testServer.handler = ^{
        [connectionExpectation fulfill];
    };
    
    LDTcpServer *tcpServer = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                          andPort:55302];
    tcpServer.tcpServerDelegate = testServer;
    [tcpServer startWithRunLoop:CFRunLoopGetMain()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFSocketContext socketContext = { 0, (__bridge void *)(self), NULL, NULL, NULL };
        CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault,
                                            AF_INET,
                                            SOCK_STREAM,
                                            IPPROTO_TCP,
                                            kCFSocketConnectCallBack,
                                            NULL,
                                            &socketContext);
        
        struct sockaddr_in sock_address;
        memset(&sock_address, 0, sizeof(sock_address));
        
        sock_address.sin_len = sizeof(sock_address);
        sock_address.sin_family = AF_INET;
        sock_address.sin_port = htons(55302);
        sock_address.sin_addr.s_addr = inet_addr("127.0.0.1");
        
        NSData *sockData = [NSData dataWithBytes:&sock_address length:sizeof(sock_address)];
        
        CFSocketConnectToAddress(socket, (__bridge CFDataRef)sockData, 4.f);
    });
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        [tcpServer stop];
    }];
}

@end
