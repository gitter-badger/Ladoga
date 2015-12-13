//
//  LDTcpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^LDTcpServerCallback)(CFSocketNativeHandle socketNativeHandle);


@interface LDTcpServer : NSObject

/**
 IP address of interface where server is running.
 */
@property (nonatomic, strong, readonly) NSString * _Nonnull address;

/**
 Port number that server is binded to.
 */
@property (nonatomic, assign, readonly) NSInteger port;

/**
 An callback that will be called by server when new connection accepted.
 */
@property (nonatomic, strong, readwrite) LDTcpServerCallback _Nullable acceptConnectionCallback;

/*
 *  You can't initialize server without required parameters.
 */
+ (instancetype _Nullable)new NS_UNAVAILABLE;
- (instancetype _Nullable)init NS_UNAVAILABLE;

/**
 Initializes server with required parameters.
 @param IP-address of interface that server should be binded to. Default is 0.0.0.0
 @param Port number that should be used to listen new connections.
 */
- (instancetype _Nullable)initWithAddress:(NSString * _Nullable)address
                                  andPort:(NSInteger)port;

/**
 Binds server to TCP port and start listening for new connections
 */
- (BOOL)startWithRunLoop:(CFRunLoopRef _Nonnull)runLoop;

/**
 Stops server
 */
- (void)stop;

@end
