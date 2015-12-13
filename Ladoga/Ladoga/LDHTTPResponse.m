//
//  LDHTTPResponse.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPResponse.h"


@interface LDHTTPResponse ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *headers;
@end


@implementation LDHTTPResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headers = [[NSMutableDictionary alloc] init];
        self.code = 200;
    }
    return self;
}

#pragma mark - Setters & getters

- (CFHTTPMessageRef)httpMessage {
    CFHTTPMessageRef httpMessage = CFHTTPMessageCreateResponse(kCFAllocatorDefault,
                                                               self.code,
                                                               NULL,
                                                               kCFHTTPVersion1_0);
    
    [self.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CFStringRef header = (__bridge CFStringRef)key;
        CFStringRef value = (__bridge CFStringRef)obj;
        CFHTTPMessageSetHeaderFieldValue(httpMessage, header, value);
    }];
    
    CFDataRef body = (__bridge CFDataRef)[self.body dataUsingEncoding:NSUTF8StringEncoding];
    CFHTTPMessageSetBody(httpMessage, body);
    
    return httpMessage;
}

#pragma mark - Public methods

- (void)addValue:(NSString *)value forHeader:(NSString *)header {
    [self.headers setObject:value forKey:header];
}

@end
