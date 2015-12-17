//
//  LDTcpServer.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDTCPServer.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


void acceptConnectionCallback(CFSocketRef s,
                              CFSocketCallBackType callbackType,
                              CFDataRef address,
                              const void *data,
                              void *info);


@interface LDTCPServer ()

@property (nonatomic, strong, readwrite) NSData *addressData;
@property (nonatomic, assign, readwrite) CFSocketRef listeningSocket;

- (NSData *)addressDataWithAddress:(NSString *)address andPort:(NSInteger)port;
- (CFSocketRef)listeningSocketWithAddressData:(NSData *)addressData;
- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle;
@end


@implementation LDTCPServer

- (instancetype)initWithAddress:(NSString *)address andPort:(NSInteger)port {
    self = [super init];
    if (self) {
        self.addressData = [self addressDataWithAddress:address andPort:port];
        self.listeningSocket = [self listeningSocketWithAddressData:self.addressData];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

#pragma mark - Setters & getters

- (NSString *)address {
    CFDataRef dataRef = CFSocketCopyAddress(self.listeningSocket);
    struct sockaddr_in *sockaddr = (struct sockaddr_in *)CFDataGetBytePtr(dataRef);
    char *cIPAddress = inet_ntoa(sockaddr->sin_addr);
    NSString *ipAddress = [NSString stringWithCString:cIPAddress
                                             encoding:NSUTF8StringEncoding];
    CFRelease(dataRef);
    return ipAddress;
}

- (NSInteger)port {
    CFDataRef dataRef = CFSocketCopyAddress(self.listeningSocket);
    struct sockaddr_in *sockaddr = (struct sockaddr_in *)CFDataGetBytePtr(dataRef);
    NSInteger port = htons(sockaddr->sin_port);
    CFRelease(dataRef);
    return port;
}

#pragma mark - Internal methods

- (NSData *)addressDataWithAddress:(NSString *)address andPort:(NSInteger)port {
    struct sockaddr_in sock_address;
    memset(&sock_address, 0, sizeof(sock_address));
    
    sock_address.sin_len = sizeof(sock_address);
    sock_address.sin_family = AF_INET;
    sock_address.sin_port = htons(port);
    sock_address.sin_addr.s_addr = address ? inet_addr(address.UTF8String) : INADDR_ANY;
    
    return [NSData dataWithBytes:&sock_address length:sizeof(sock_address)];
}

- (CFSocketRef)listeningSocketWithAddressData:(NSData *)addressData {
    CFSocketContext socketContext = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    
    CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault,
                                        AF_INET,
                                        SOCK_STREAM,
                                        IPPROTO_TCP,
                                        kCFSocketAcceptCallBack,
                                        acceptConnectionCallback,
                                        &socketContext);
    
    return socket;
}

- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle {
    if (self.tcpServerDelegate) {
        if ([self.tcpServerDelegate respondsToSelector:@selector(acceptConnection:)]) {
            [self.tcpServerDelegate acceptConnection:nativeSocketHandle];
        }
    }
}

#pragma mark - Public methods

- (BOOL)startWithRunLoop:(CFRunLoopRef)runLoop {
    CFSocketError error = CFSocketSetAddress(self.listeningSocket, (CFDataRef)self.addressData);
    if (error != kCFSocketSuccess) {
        return NO;
    }
    
    CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,
                                                                   self.listeningSocket,
                                                                   0);

    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopCommonModes);
    
    CFRelease(runLoopSource);
    
    return YES;
}

- (void)stop {
    CFSocketInvalidate(self.listeningSocket);
}

@end


#pragma mark - C functions

void acceptConnectionCallback(CFSocketRef s,
                              CFSocketCallBackType callbackType,
                              CFDataRef address,
                              const void *data,
                              void *info) {
    LDTCPServer *server = (__bridge LDTCPServer *)info;
    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
    [server handleNewNativeSocket:nativeSocketHandle];
}
