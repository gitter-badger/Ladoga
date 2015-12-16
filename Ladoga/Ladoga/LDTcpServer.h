//
//  LDTcpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LDTcpServerDelegate <NSObject>
@optional
- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle;
@end



@interface LDTcpServer : NSObject

/**
 IP address of interface where server is running.
 */
@property (nonatomic, strong, readonly) NSString *address;

/**
 Port number that server is binded to.
 */
@property (nonatomic, assign, readonly) NSInteger port;

/**
 An callback that will be called by server when new connection accepted.
 */
@property (nonatomic, weak, readwrite) id <LDTcpServerDelegate> tcpServerDelegate;

/*
 *  You can't initialize server without required parameters.
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes server with required parameters.
 
 address: 
 IP-address of interface that server should be binded to. Default is 0.0.0.0
 
 port: 
 Port number that should be used to listen new connections.
 */
- (instancetype)initWithAddress:(NSString *)address
                        andPort:(NSInteger)port;

/**
 Binds server to TCP port and start listening for new connections
 */
- (BOOL)startWithRunLoop:(CFRunLoopRef)runLoop;

/**
 Stops server
 */
- (void)stop;

@end
