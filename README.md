[![Travis CI](https://api.travis-ci.org/aperechnev/Ladoga.svg?branch=develop)](https://travis-ci.org/aperechnev/Ladoga) [![CocoaPods](http://cocoapods.org/pods/Ladoga)](http://cocoapod-badges.herokuapp.com/v/Ladoga/0.1/badge.png)

# Ladoga
Ladoga is an lightweight and easy-to-use HTTP framework that makes it possible to write web-applications in Objective-C.

# Example
The basic example is easy enough, so you can start making you web applications right now.

###### MyServerExample.h
```Objective-C
#import <Foundation/Foundation.h>
#import <Ladoga/Ladoga.h>

@interface MyServerExample : NSObject <LDHTTPServerDelegate>
- (void)start;
@end
```

###### MyServerExample.m
```Objective-C
#import "MyServerExample.h"

@implementation MyServerExample

- (void)start {
    LDHTTPServer *server = [[LDHTTPServer alloc] initWithAddress:@"127.0.0.1"
                                                         andPort:8080];
    server.httpServerDelegate = self;
    [server startWithRunLoop:CFRunLoopGetMain()];
    CFRunLoopRun();
}

- (LDHTTPResponse *)processRequest:(LDHTTPRequest *)request {
    LDHTTPResponse *response = [[LDHTTPResponse alloc] init];
    [response addValue:@"text/html;charset=utf-8" forHTTPHeader:@"Content-Type"];
    response.body = @"<html><head><title>My Example</title></head><body>Hello, world!</body></html>";
    return response;
}

@end
```
