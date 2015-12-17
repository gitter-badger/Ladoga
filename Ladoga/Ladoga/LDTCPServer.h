//
//  LDTcpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LDTCPServerDelegate <NSObject>
@optional
- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle;
@end


/**
 @brief An class which implements the base TCP server.
 
 @discussion Actually you don't need to use this class since you want to run
    an HTTP server. Use LDHTTPServer class, which inherits LDTCPServer and 
    provides required functionality.
 */
@interface LDTCPServer : NSObject

/**
 @brief IP address of interface where server is running.
 
 @discussion The default value is 0.0.0.0, which means that server is available
                an all existing interfaces.
 */
@property (nonatomic, strong, readonly) NSString *address;

/**
 @brief Port number that server is binded to.
 
 @discussion The default value is 0, which means that server will choose one of
                available ports and bind to it.
 */
@property (nonatomic, assign, readonly) NSInteger port;

/**
 @brief An callback that will be called by server when new connection accepted.
 */
@property (nonatomic, weak, readwrite) id <LDTCPServerDelegate> tcpServerDelegate;

/*
 *  You can't initialize server without required parameters.
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Initializes server with required parameters.
 
 @param IP-address of interface that server should be binded to. Default is 0.0.0.0.
 @param Port number that should be used to listen new connections.
 
 @return Returns an initialized, ready-to-run instance.
 */
- (instancetype)initWithAddress:(NSString *)address
                        andPort:(NSInteger)port;

/**
 @brief Binds server to TCP port and start listening for new connections.
 @return Return value indicates if server runned successfully.
 */
- (BOOL)startWithRunLoop:(CFRunLoopRef)runLoop;

/**
 @brief Stops server.
 */
- (void)stop;

@end
