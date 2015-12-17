//
//  LDHTTPRequest.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 @brief An class that represents HTTP requests.
 */
@interface LDHTTPRequest : NSObject

/**
 */
@property (nonatomic, assign, readonly) NSInteger method;

/**
 */
@property (nonatomic, strong, readonly) NSURL *uri;

/**
 */
@property (nonatomic, strong, readonly) NSDictionary *HTTPHeaders;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage;

/**
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

@end
