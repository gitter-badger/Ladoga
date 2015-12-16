//
//  LDHTTPRequestTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 14.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LDHTTPRequest.h"
#import "LDHttpServer.h"


@interface LDHTTPRequestTest : XCTestCase
@end


@implementation LDHTTPRequestTest

- (void)testInitialization {
    NSString * const requestMethod = @"POST";
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

    XCTAssertEqual(request.method, LDHTTPMethodPOST);
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
    NSString * const OPTIONS    = @"OPTIONS";
    NSString * const GET        = @"GET";
    NSString * const HEAD       = @"HEAD";
    NSString * const POST       = @"POST";
    NSString * const PUT        = @"PUT";
    NSString * const PATCH      = @"PATCH";
    NSString * const DELETE     = @"DELETE";
    NSString * const TRACE      = @"TRACE";
    NSString * const CONNECT    = @"CONNECT";
    
    CFHTTPMessageRef httpMessage;
    LDHTTPRequest *request;
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)UNKNOWN,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodUnknown);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)OPTIONS,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodOPTIONS);
    
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
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)POST,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodPOST);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)PUT,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodPUT);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)PATCH,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodPATCH);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)DELETE,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodDELETE);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)TRACE,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodTRACE);
    
    httpMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                             (__bridge CFStringRef)CONNECT,
                                             requestURL,
                                             requestHTTPVersion);
    request = [[LDHTTPRequest alloc] initWithMessage:httpMessage];
    XCTAssertEqual(request.method, LDHTTPMethodCONNECT);
}

@end
