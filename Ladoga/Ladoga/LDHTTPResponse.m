//
//  LDHTTPResponse.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPResponse.h"


@interface LDHTTPResponse ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *HTTPHeaders;
@end


@implementation LDHTTPResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        self.HTTPHeaders = [[NSMutableDictionary alloc] init];
        self.code = 200;
        self.body = @"";
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code {
    self = [super init];
    if (self) {
        self.HTTPHeaders = [[NSMutableDictionary alloc] init];
        self.code = code;
        
        NSDictionary *params = @{ @"StatusCode": [NSString stringWithFormat:@"%@", @(code)],
                                  @"Title": @"Response code" };
        
        NSString *templatePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"response.html"];
        
        self.body = [LDHTMLTemplate renderTemplateAtPath:templatePath
                                          withParameters:params];;
    }
    return self;
}

#pragma mark - Setters & getters

- (CFHTTPMessageRef)httpMessage {
    CFHTTPMessageRef httpMessage = CFHTTPMessageCreateResponse(kCFAllocatorDefault,
                                                               self.code,
                                                               NULL,
                                                               kCFHTTPVersion1_1);
    
    [self.HTTPHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        CFStringRef header = (__bridge CFStringRef)key;
        CFStringRef value = (__bridge CFStringRef)obj;
        CFHTTPMessageSetHeaderFieldValue(httpMessage, header, value);
    }];
    
    CFDataRef body = (__bridge CFDataRef)[self.body dataUsingEncoding:NSUTF8StringEncoding];
    CFHTTPMessageSetBody(httpMessage, body);
    
    return httpMessage;
}

#pragma mark - Public methods

- (NSString *)valueForHTTPHeader:(NSString *)header {
    return [self.HTTPHeaders objectForKey:header];
}

- (void)addValue:(NSString *)value forHTTPHeader:(NSString *)header {
    @synchronized(self.HTTPHeaders) {
        [self.HTTPHeaders setObject:value forKey:header];
    }
}

- (void)deleteHTTPHeader:(NSString *)header {
    @synchronized(self.HTTPHeaders) {
        [self.HTTPHeaders removeObjectForKey:header];
    }
}

@end
