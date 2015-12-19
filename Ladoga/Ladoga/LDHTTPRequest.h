//
//  LDHTTPRequest.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSInteger {
    LDHTTPMethodUnknown = -1,
//    LDHTTPMethodOPTIONS,
    LDHTTPMethodGET,
    LDHTTPMethodHEAD,
//    LDHTTPMethodPOST,
//    LDHTTPMethodPUT,
//    LDHTTPMethodPATCH,
//    LDHTTPMethodDELETE,
//    LDHTTPMethodTRACE,
//    LDHTTPMethodCONNECT
} LDHTTPMethod;


/**
 @brief An class that represents HTTP requests.
 */
@interface LDHTTPRequest : NSObject

/**
 @brief HTTP method of request.
 */
@property (nonatomic, assign, readonly) NSInteger method;

/**
 @brief Request URI.
 */
@property (nonatomic, strong, readonly) NSURL *uri;

/**
 @brief HTTP version.
 */
@property (nonatomic, strong, readonly) NSString *httpVersion;

/**
 @brief Contains arguments, if passed with request.
 */
@property (nonatomic, strong, readonly) NSDictionary *arguments;

/**
 */
- (NSDictionary *)parseArgumentsFromURL:(NSString *)uri;

/**
 @brief Request headers.
 */
@property (nonatomic, strong, readonly) NSDictionary *HTTPHeaders;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage;

/**
 @brief Access to pointed HTTP header.
 
 @param The name of HTTP header, e.g. @"User-Agent".
 
 @return The value of the header. Returns nil if there is no header or
 no value.
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

@end
