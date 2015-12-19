//
//  LDHttpServer.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPServer.h"
#import "LDTCPServer.h"


static const NSUInteger LD_MAX_REQUEST_BYTES = 2048;


@interface LDHTTPServer ()

@property (nonatomic, strong, readonly) NSMutableDictionary *requestHandlers;

- (LDHTTPRequest *)readRequest:(CFSocketNativeHandle)socket;
- (void)sendResponse:(LDHTTPResponse *)response toSocket:(CFSocketNativeHandle)socket;
@end


@implementation LDHTTPServer

- (instancetype)initWithAddress:(NSString *)address andPort:(NSInteger)port {
    self = [super initWithAddress:address andPort:port];
    if (self) {
        self.tcpServerDelegate = self;
        _requestHandlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - TCP server delegate

- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle {
    LDHTTPRequest *request = [self readRequest:socketNativeHandle];
    
    if (request.method == LDHTTPMethodUnknown) {
        LDHTTPResponse *response = [[LDHTTPResponse alloc] initWithCode:LD_HTTP_RESPONSE_CODE_NOT_IMPLEMENTED];
        [self sendResponse:response toSocket:socketNativeHandle];
        return;
    }
    
    LDHTTPRequestHandler *requestHandler = [self.requestHandlers objectForKey:request.uri.relativePath];
    if (requestHandler == nil) {
        LDHTTPResponse *response = [[LDHTTPResponse alloc] initWithCode:LD_HTTP_RESPONSE_CODE_NOT_FOUND];
        [self sendResponse:response toSocket:socketNativeHandle];
        return;
    }
    
    if ([requestHandler.methods containsObject:@(request.method)] == NO) {
        LDHTTPResponse *response = [[LDHTTPResponse alloc] initWithCode:LD_HTTP_RESPONSE_CODE_METHOD_NOT_ALLOWED];
        [self sendResponse:response toSocket:socketNativeHandle];
        return;
    }
    
    LDHTTPResponse *response = [requestHandler.handler performSelector:requestHandler.selector
                                                            withObject:request];
    
    if (response) {
        [self sendResponse:response toSocket:socketNativeHandle];
    }
    else {
        LDHTTPResponse *response = [[LDHTTPResponse alloc] initWithCode:LD_HTTP_RESPONSE_CODE_INTERNAL_SERVER_ERROR];
        [self sendResponse:response toSocket:socketNativeHandle];
    }
}

#pragma mark - Internal methods

- (LDHTTPRequest *)readRequest:(CFSocketNativeHandle)socket {
    unsigned char *receivedData = malloc(LD_MAX_REQUEST_BYTES);
    NSInteger n = read(socket, receivedData, LD_MAX_REQUEST_BYTES);
    
    CFHTTPMessageRef httpMessage = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, YES);
    CFHTTPMessageAppendBytes(httpMessage, receivedData, n);
    free(receivedData);
    
    LDHTTPRequest *request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    CFRelease(httpMessage);
    return request;
}

- (void)sendResponse:(LDHTTPResponse *)response toSocket:(CFSocketNativeHandle)socket {
    NSData *data = (__bridge_transfer NSData *)CFHTTPMessageCopySerializedMessage(response.httpMessage);
    write(socket, [data bytes], [data length]);
}

#pragma mark - Public interface

- (void)addRequestHandler:(LDHTTPRequestHandler *)requestHandler forPath:(NSString *)path {
    [self.requestHandlers addEntriesFromDictionary:@{ path: requestHandler }];
}

@end
