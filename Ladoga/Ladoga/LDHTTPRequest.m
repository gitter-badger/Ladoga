//
//  LDHTTPRequest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPRequest.h"
#import "LDHTTPServer.h"


@interface LDHTTPRequest ()

- (LDHTTPMethod)httpMethodFromString:(NSString *)methodString;
@end


@implementation LDHTTPRequest

@synthesize HTTPHeaders = _HTTPHeaders;

- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage {
    self = [super init];
    if (self) {
        _uri = (__bridge NSURL *)CFHTTPMessageCopyRequestURL(httpMessage);
        _method = [self httpMethodFromString:(__bridge_transfer NSString *)CFHTTPMessageCopyRequestMethod(httpMessage)];
        _HTTPHeaders = (__bridge_transfer NSDictionary *)CFHTTPMessageCopyAllHeaderFields(httpMessage);
    }
    return self;
}

#pragma mark - Public methods

- (NSString *)valueForHTTPHeader:(NSString *)header {
    return [self.HTTPHeaders objectForKey:header];
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
    if ([methodString isEqualToString:@"HEAD"]) {
        return LDHTTPMethodHEAD;
    }
    if ([methodString isEqualToString:@"PATCH"]) {
        return LDHTTPMethodPATCH;
    }
    if ([methodString isEqualToString:@"OPTIONS"]) {
        return LDHTTPMethodOPTIONS;
    }
    if ([methodString isEqualToString:@"TRACE"]) {
        return LDHTTPMethodTRACE;
    }
    if ([methodString isEqualToString:@"CONNECT"]) {
        return LDHTTPMethodCONNECT;
    }
    
    return LDHTTPMethodUnknown;
}

@end
