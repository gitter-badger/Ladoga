//
//  LDHTTPResponseTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Ladoga.h"


@interface LDHTTPResponseTest : XCTestCase
@end


@implementation LDHTTPResponseTest

- (void)testInitialization {
    id response = [[LDHTTPResponse alloc] init];
    XCTAssertNotNil(response);
    XCTAssertTrue([response isKindOfClass:[LDHTTPResponse class]]);
}

- (void)testResponseCode {
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    XCTAssertEqual(response.code, 200);
    
    response.code = 404;
    XCTAssertEqual(response.code, 404);
}

- (void)testBody {
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    XCTAssertEqualObjects(response.body, @"");
    
    NSString * const body = @"<html></html>";
    response.body = body;
    XCTAssertEqual(response.body, body);
}

- (void)testHTTPMessage {
    NSString * const BODY = @"<html></html>";
    const NSInteger CODE = 500;
    
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    response.code = CODE;
    response.body = BODY;
    CFHTTPMessageRef httpMessage = response.httpMessage;
    
    NSInteger testCode = CFHTTPMessageGetResponseStatusCode(httpMessage);
    XCTAssertEqual(testCode, CODE);
    
    NSData *testData = (__bridge_transfer NSData *)CFHTTPMessageCopyBody(httpMessage);
    NSString *testBody = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(testBody, BODY);
}

- (void)testHeaders {
    NSString * const headerKey = @"Some-header";
    NSString * const headerValue = @"wow-value";
    
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    [response addValue:headerValue forHeader:headerKey];
    CFHTTPMessageRef httpMessage = response.httpMessage;
    
    NSString *testHeaderValue = (__bridge NSString *)CFHTTPMessageCopyHeaderFieldValue(httpMessage, (__bridge CFStringRef)headerKey);
    XCTAssertEqualObjects(testHeaderValue, headerValue);
}

@end
