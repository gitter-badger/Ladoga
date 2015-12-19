//
//  LDHTTPResponse.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDHTMLTemplate.h"


/**
 @brief Class that represents HTTP response.
 
 @discussion Use object of this class to return a response to client.
 */
@interface LDHTTPResponse : NSObject

/**
 @brief CF representation of response.
 */
@property (nonatomic, assign, readonly) CFHTTPMessageRef httpMessage;

/**
 @brief Response code.
 */
@property (nonatomic, assign, readwrite) NSUInteger code;

/**
 @brief Response body.
 */
@property (nonatomic, strong, readwrite) NSString *body;

/**
 @brief Value for HTTP header.
 
 @param Header name.
 
 @return Return header value or nil if header doesn't exist..
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

/**
 @brief Adds new header to response.
 
 @discuss Adds new header or set new value if header already exists.
 
 @param Header value.
 @param Header name.
 */
- (void)addValue:(NSString *)value forHTTPHeader:(NSString *)header;

/**
 @brief Deletes header.
 
 @param Header name.
 */
- (void)deleteHTTPHeader:(NSString *)header;

/**
 @brief Creates an instance of error response with 500 status code.
 
 @discussion Use this class methods to create new response object initialized with default
    values for "Internal server error" (500) response.
 
 @return Return an initialized instance of response.
 */
+ (instancetype)internalServerErrorResponse;

+ (instancetype)responseWithCode:(NSInteger)code andMessage:(NSString *)message;

@end
