//
//  LDHTTPRequestHandler.m
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTTPRequestHandler.h"


@implementation LDHTTPRequestHandler

- (instancetype)initWithHandler:(NSObject *)handler selector:(SEL)selector methods:(NSArray *)methods {
    self = [self init];
    if (self) {
        _handler = handler;
        _selector = selector;
        _methods = methods;
    }
    return self;
}

@end
