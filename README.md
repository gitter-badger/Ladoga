[![Travis CI](https://api.travis-ci.org/aperechnev/Ladoga.svg?branch=develop)](https://travis-ci.org/aperechnev/Ladoga) [![CocoaPods](https://cocoapod-badges.herokuapp.com/v/Ladoga/badge.png)](http://cocoapods.org/pods/Ladoga) ![CocoaPods](https://cocoapod-badges.herokuapp.com/l/Ladoga/badge.png)

**Ladoga** is a lightweight and easy-to-use HTTP framework that makes it possible to write web-applications in Objective-C. It provides simple API letting you to concentrate on you bussiness logic, instead of spending your time on low-level details.

## Installation

The easiest way to start development using **Ladoga** framework is to install it via CocoaPods. Just add it to your `Podfile`:

```Podspec
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'Ladoga'
```

## Getting started

### Basic example

The basic example is easy enough, so you can start making you web applications right now.

###### MyServerExample.h
```Objective-C
#import <Foundation/Foundation.h>
#import <Ladoga/Ladoga.h>

@interface MyServerExample : NSObject
- (void)start;
@end
```

###### MyServerExample.m
```Objective-C
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
```

### Templates

**Ladoga** also provides template system via `LDHTMLTemplate` class. You can specify your templates with some variables, and then render it with actual values.

Let's say that we have the following template with `PageTitle` and `Username` variables:

```HTML
<html>
<head><title>{{ PageTitle }}</title></head>
<body>Hello, {{ Username }}!</body>
</html>
```

So, to render this template, we have to use `renderTemplateAtPath:withParameters:` class method:

```Objective-C
NSDictionary *params = @{ @"PageTitle": @"Test Page",
                          @"Username": @"John" };
    
NSString *templatePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"index.html"];
    
NSString *resultHTML = [LDHTMLTemplate renderTemplateAtPath:templatePath
                                             withParameters:params];
```

And as a result, we have a string that contains the code of rendered HTML page:

```HTML
<html>
<head><title>Test Page</title></head>
<body>Hello, John!</body>
</html>
```

## How To Contribute

If you want to help to develop **Ladoga**, your pull requests are welcome. Please follow the `git-flow` notation and make sure that all tests are passed before making a pull-request. Btw, every line of code should be covered by tests. All warnings should be fixed as well.
