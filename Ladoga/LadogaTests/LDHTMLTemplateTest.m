//
//  LDHTMLTemplateTest.m
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LDHTMLTemplate.h"


@interface LDHTMLTemplateTest : XCTestCase
@end


@implementation LDHTMLTemplateTest

- (void)testVariablesRendering {
    NSDictionary *params = @{ @"PageTitle": @"Test Page",
                              @"Name": @"Some Username" };
    
    NSString *templatePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"index.html"];
    XCTAssertNotNil(templatePath);
    
    NSString *resultHTML = [LDHTMLTemplate renderTemplateAtPath:templatePath
                                                 withParameters:params];
    
    XCTAssertNotNil(resultHTML);
    XCTAssertFalse([resultHTML rangeOfString:@"<title>Test Page</title>"].location == NSNotFound);
    XCTAssertFalse([resultHTML rangeOfString:@"<h1>Test Page</h1>"].location == NSNotFound);
    XCTAssertFalse([resultHTML rangeOfString:@"<p>Hello, Some Username</p>"].location == NSNotFound);
}

- (void)testNoTemplate {
    NSString *resultHTML = [LDHTMLTemplate renderTemplateAtPath:@"no.html"
                                                 withParameters:@{}];
    XCTAssertNil(resultHTML);
}

@end
