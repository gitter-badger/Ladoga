//
//  LDTcpServerTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Ladoga.h"


@interface LDTcpServerTest : XCTestCase
@end


@implementation LDTcpServerTest

- (void)testInitialization {
    LDTcpServer *tcpServer = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1"
                                                          andPort:55300];
    XCTAssertNotNil(tcpServer);
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
    XCTFail(@"Test is not implemented.");
}

@end
