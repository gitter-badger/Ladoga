//
//  LDHTTPRequest.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 @typedef LDHTTPMethod
 
 @brief LDHTTPMethod enumerate HTTP request methods, supported by server.
 */
typedef enum : NSInteger {
    
    /**
     @brief Unknown HTTP request method.
     */
    LDHTTPMethodUnknown = -1,
    
    /**
     @brief GET method.
     */
    LDHTTPMethodGET,
    
    /**
     @brief HEAD method.
     */
    LDHTTPMethodHEAD,
    
//    LDHTTPMethodOPTIONS,
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
 @brief Parses arguments from relative path.
 
 @discussion Usually you don't need to call this method, because LDHTTPRequest
    object uses it itself.
 
 @param uri Relative path that contains parameters.
 
 @return Dictionary that contains parsed parameters with values as a key-value storage.
 */
- (NSDictionary *)parseArgumentsFromURL:(NSString *)uri;

/**
 @brief Request headers.
 */
@property (nonatomic, strong, readonly) NSDictionary *HTTPHeaders;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Initializes object with specified http message object.
 
 @discussion Usually you don't need to use this methods because LDHTTPServer calls
    it for you when parses a request.
 
 @return An initialized object.
 */
- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage;

/**
 @brief Access to pointed HTTP header.
 
 @param header The name of HTTP header, e.g. @"User-Agent".
 
 @return The value of the header. Returns nil if there is no header or
 no value.
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

@end
