//
//  LDTcpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Protocol describes the events, that you can handle from `LDTCPServer`.
 */
@protocol LDTCPServerDelegate <NSObject>

@optional

/**
 TCP server invokes this method when new connection becomes ready.
 
 @param socketNativeHandle Native socket that is ready to interract with server's logic.
 */
- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle;

@end


/**
 Class that implements base TCP server. Actually you don't need to use this class since you want to run an HTTP server. Use `LDHTTPServer` class, which inherits `LDTCPServer` and provides required functionality.
 
 ## Initialization
 
 Use `initWithAddress:andPort:` method to initialize TCP server:
 
    id tcpServer = [[LDTCPServer alloc] initWithAddress:@"127.0.0.1" andPort:8080];
 
 You are able to change it's address and port throug the appropriate properties, but keep in mind that it is possible only before server is running.
 
 ## Listening For New Connections
 
 When `LDTCPServer` runs, it starts listening for new connections from clients' software. Once new connection established, server invokes the `acceptConnection:` method of `LDTCPServerDelegate`. That means that new connection is accepted and ready to data exchanging. To handle this connection, you should implement `LDTCPServerDelegate` protocol in one of your classes, and after that you should assign your delegate to `delegate` property of `LDTCPServer` instance.
 
 ## Server Running
 
 When you have created an instance of `LDTCPServerDelegate` and set it's delegate, you can run server calling `startWithRunLoop:` method. To stop server just call `stop` method.
 
 */
@interface LDTCPServer : NSObject

///=====================
/// @name Initialization
///=====================

/*
 *  You can't initialize server without required parameters.
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes server with required parameters.
 
 @param address IP-address of interface that server should be binded to. Default is 0.0.0.0.
 @param port Port number that should be used for listening new connections.
 
 @return Returns an initialized, ready-to-run instance.
 */
- (instancetype)initWithAddress:(NSString *)address
                        andPort:(NSInteger)port;

///===========================
/// @name Server Configuration
///===========================

/**
 IP address of interface where server is running. The default value is 0.0.0.0, which means that server is available to all existing interfaces.
 */
@property (nonatomic, strong, readonly) NSString *address;

/**
 Port number that server is binded to. The default value is 0, which means that server will choose one of available ports and bind to it.
 */
@property (nonatomic, assign, readonly) NSInteger port;

/**
 Delegate, that handles events from `LDTCPServer`.
 
 @see `LDTCPServerDelegate`
 */
@property (nonatomic, weak, readwrite) id <LDTCPServerDelegate> tcpServerDelegate;

///============================
/// @name Starting And Stopping
///============================

/**
 Binds server to TCP port and start listening for new connections.
 
 @return Return value indicates if server runned successfully.
 */
- (BOOL)startWithRunLoop:(CFRunLoopRef)runLoop;

/**
 Stops server.
 */
- (void)stop;

@end
