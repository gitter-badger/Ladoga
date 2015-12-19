//
//  LDHTTPRequestTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 14.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LDHTTPRequest.h"
#import "LDHTTPServer.h"


@interface LDHTTPRequestTest : XCTestCase
@end


@implementation LDHTTPRequestTest

- (void)testInitialization {
    NSString * const requestMethod = @"HEAD";
    const NSURL *requestURL = [NSURL URLWithString:@"http://127.0.0.1/index.html"];
    const NSString * const requestHTTPVersion = @"1.0";
    
    NSString * const testHTTPHeaderField = @"User-Agent";
    NSString * const testHTTPHeaderValue = @"My-user-agent";
    
    CFHTTPMessageRef httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                                              (__bridge CFStringRef)requestMethod,
                                                              (__bridge CFURLRef)requestURL, (__bridge CFStringRef)requestHTTPVersion);
    
    CFHTTPMessageSetHeaderFieldValue(httpMessage,
                                     (__bridge CFStringRef)testHTTPHeaderField, (__bridge CFStringRef)testHTTPHeaderValue);
    
    LDHTTPRequest *request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];

    XCTAssertEqual(request.method, LDHTTPMethodHEAD);
    XCTAssertEqualObjects([request valueForHTTPHeader:testHTTPHeaderField], testHTTPHeaderValue);
    
    NSDictionary *requestHeaders = request.HTTPHeaders;
    XCTAssertEqualObjects([requestHeaders objectForKey:testHTTPHeaderField], testHTTPHeaderValue);
    
    XCTAssertTrue([request.uri isKindOfClass:[NSURL class]]);
    XCTAssertEqualObjects(request.uri, requestURL);
}

- (void)testHTTPMethods {
    const CFURLRef requestURL = (__bridge CFURLRef)[NSURL URLWithString:@"http://127.0.0.1/index.html"];
    const CFStringRef requestHTTPVersion = (__bridge CFStringRef)@"1.0";
    
    NSString * const UNKNOWN    = @"UNKNOWN";
    NSString * const GET        = @"GET";
    NSString * const HEAD       = @"HEAD";
    
    CFHTTPMessageRef httpMessage;
    LDHTTPRequest *request;
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)UNKNOWN,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodUnknown);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)GET,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodGET);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)HEAD,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodHEAD);
}

- (void)testGETArgumentsParsing {
    const CFStringRef requestHTTPVersion = (__bridge CFStringRef)@"1.0";
    const CFStringRef requestHTTPMethod = (__bridge CFStringRef)@"GET";
    
    NSArray *testURLStrings = @[
  @[ @"http://127.0.0.1", @{} ],
  @[ @"http://127.0.0.1/", @{} ],
  @[ @"http://127.0.0.1/index.html", @{} ],
  @[ @"http://127.0.0.1/?", @{} ],
  @[ @"http://127.0.0.1/?some", @{ @"some": @"" } ],
  @[ @"http://127.0.0.1/?some=", @{ @"some": @"" } ],
  @[ @"http://127.0.0.1/?some=1", @{ @"some": @"1" } ],
  @[ @"http://127.0.0.1/index.html?some=1", @{ @"some": @"1" } ],
  @[ @"http://127.0.0.1/index.html?some=1&another=test", @{ @"some": @"1", @"another": @"test" } ]
  ];
    
    for (NSArray *testParameters in testURLStrings) {
        CFURLRef url = (__bridge CFURLRef)[NSURL URLWithString:testParameters[0]];
        
        CFHTTPMessageRef httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                                                  requestHTTPMethod,
                                                                  url,
                                                                  requestHTTPVersion);
        
        LDHTTPRequest *request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
        
        NSDictionary *passedParams = testParameters[1];
        for (NSString *parameterName in passedParams) {
            XCTAssertEqualObjects([request.arguments objectForKey:parameterName], [passedParams objectForKey:parameterName]);
        }
    }
}

@end
