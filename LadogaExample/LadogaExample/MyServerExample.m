//
//  MyServerExample.m
//  LadogaExample
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "MyServerExample.h"


@implementation MyServerExample

- (void)start {
    LDHTTPServer *server = [[LDHTTPServer alloc] initWithAddress:@"127.0.0.1"
                                                         andPort:8081];
    
    LDHTTPRequestHandler *mainPageHandler = [[LDHTTPRequestHandler alloc] initWithHandler:self
                                                                                 selector:@selector(mainPage:)
                                                                                  methods:@[ @(LDHTTPMethodGET) ]];
    [server addRequestHandler:mainPageHandler forPath:@"/index.html"];
    [server startWithRunLoop:CFRunLoopGetMain()];
    CFRunLoopRun();
}

- (LDHTTPResponse *)mainPage:(LDHTTPRequest *)request {
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    [response addValue:@"text/html;charset=utf-8" forHTTPHeader:@"Content-Type"];
    response.body = @"<html><head><title>My Example</title></head><body>Hello, world!</body></html>";
    return response;
}

@end
