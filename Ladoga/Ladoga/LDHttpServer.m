//
//  LDHttpServer.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHttpServer.h"
#import "LDTcpServer.h"


static const NSUInteger LD_MAX_REQUEST_BYTES = 2048;


@interface LDHttpServer ()

- (LDHTTPRequest *)readRequest:(CFSocketNativeHandle)socket;
- (void)sendResponse:(LDHTTPResponse *)response toSocket:(CFSocketNativeHandle)socket;
@end


@implementation LDHttpServer

- (instancetype)initWithAddress:(NSString *)address andPort:(NSInteger)port {
    self = [super initWithAddress:address andPort:port];
    if (self) {
        self.tcpServerDelegate = self;
    }
    return self;
}

#pragma mark - TCP server delegate

- (void)acceptConnection:(CFSocketNativeHandle)socketNativeHandle {
    LDHTTPRequest *request = [self readRequest:socketNativeHandle];
    
    if (self.httpServerDelegate) {
        LDHTTPResponse *response = [self.httpServerDelegate processRequest:request];
        if (response) {
            [self sendResponse:response toSocket:socketNativeHandle];
        }
        else {
            [self sendResponse:[LDHTTPResponse internalServerErrorResponse]
                      toSocket:socketNativeHandle];
        }
    }
    else {
        [self sendResponse:[LDHTTPResponse internalServerErrorResponse]
                  toSocket:socketNativeHandle];
    }
    
    close(socketNativeHandle);
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

@end
