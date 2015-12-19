//
//  LDHTTPRequestHandler.h
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LDHTTPRequestHandler : NSObject

@property (nonatomic, strong, readwrite) NSObject *handler;
@property (nonatomic, assign, readwrite) SEL selector;
@property (nonatomic, strong, readwrite) NSArray *methods;

- (instancetype)initWithHandler:(NSObject *)handler selector:(SEL)selector methods:(NSArray *)methods;
@end
