//
//  LDHTTPRequest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPRequest.h"
#import "LDHttpServer.h"


@interface LDHTTPRequest ()

- (LDHTTPMethod)httpMethodFromString:(NSString *)methodString;
@end


@implementation LDHTTPRequest

- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage {
    self = [super init];
    if (self) {
        _userAgent = (__bridge NSString *)CFHTTPMessageCopyHeaderFieldValue(httpMessage, (__bridge CFStringRef)@"User-Agent");
        _uri = (__bridge NSString *)CFHTTPMessageCopyRequestURL(httpMessage);
        _method = [self httpMethodFromString:(__bridge NSString *)CFHTTPMessageCopyRequestMethod(httpMessage)];
    }
    return self;
}

#pragma mark - Internal methods

- (LDHTTPMethod)httpMethodFromString:(NSString *)methodString {
    NSString *method = [methodString uppercaseString];
    if ([method isEqualToString:@"GET"]) {
        return LDHTTPMethodGET;
    }
    if ([method isEqualToString:@"POST"]) {
        return LDHTTPMethodPOST;
    }
    if ([methodString isEqualToString:@"PUT"]) {
        return LDHTTPMethodPUT;
    }
    if ([methodString isEqualToString:@"DELETE"]) {
        return LDHTTPMethodDELETE;
    }
    return LDHTTPMethodUnknown;
}

@end
