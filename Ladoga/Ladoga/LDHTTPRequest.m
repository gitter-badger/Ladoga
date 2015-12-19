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

- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage {
    self = [super init];
    if (self) {
        _uri = (__bridge NSURL *)CFHTTPMessageCopyRequestURL(httpMessage);
        _method = [self httpMethodFromString:(__bridge_transfer NSString *)CFHTTPMessageCopyRequestMethod(httpMessage)];
        _httpVersion = (__bridge_transfer NSString *)(CFHTTPMessageCopyVersion(httpMessage));
        _HTTPHeaders = (__bridge_transfer NSDictionary *)CFHTTPMessageCopyAllHeaderFields(httpMessage);
        _arguments = [self argumentsForHTTPMessage:httpMessage];
    }
    return self;
}

- (NSDictionary *)argumentsForHTTPMessage:(CFHTTPMessageRef)message {
    if (_method == LDHTTPMethodGET || _method == LDHTTPMethodHEAD) {
        return [self parseArgumentsFromURL:self.uri.relativeString];
    }
    return @{};
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
    if ([methodString isEqualToString:@"HEAD"]) {
        return LDHTTPMethodHEAD;
    }
    
    return LDHTTPMethodUnknown;
}

#pragma mark - Arguments parsing

- (NSDictionary *)parseArgumentsFromURL:(NSString *)uri {
    if ([uri rangeOfString:@"?"].location == NSNotFound) {
        return @{};
    }
    
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
    
    NSString *argumentsString = [[uri componentsSeparatedByString:@"?"] lastObject];
    if (argumentsString.length == 0) {
        return @{};
    }
    
    NSArray *argumentStringList = [argumentsString componentsSeparatedByString:@"&"];
    for (NSString *argumentItem in argumentStringList) {
        NSArray *argumentComponents = [argumentItem componentsSeparatedByString:@"="];
        
        NSString *paramName = argumentComponents[0];
        NSString *paramValue = argumentComponents.count > 1 ? argumentComponents[1] : @"";
        
        [arguments addEntriesFromDictionary:@{ paramName: paramValue }];
    }
    
    NSLog(@"%@", arguments);
    
    return [arguments copy];
}

@end
