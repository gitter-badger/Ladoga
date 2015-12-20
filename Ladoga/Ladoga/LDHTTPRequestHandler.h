//
//  LDHTTPRequestHandler.h
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Class that represents request handler for specified path.
 */
@interface LDHTTPRequestHandler : NSObject

///=====================
/// @name Initialization
///=====================

/**
 Initializes object with specified values.
 */
- (instancetype)initWithHandler:(NSObject *)handler selector:(SEL)selector methods:(NSArray *)methods;

///====================
/// @name Configuration
///====================

/**
 Pointer to object, that handle HTTP request.
 */
@property (nonatomic, strong, readwrite) NSObject *handler;

/**
 Selector of the method, that will be invoked to process HTTP request.
 */
@property (nonatomic, assign, readwrite) SEL selector;

/**
 List of allowed HTTP request methods.
 */
@property (nonatomic, strong, readwrite) NSArray *methods;

@end
