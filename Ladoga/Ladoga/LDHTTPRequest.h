//
//  LDHTTPRequest.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Enumeration of HTTP request methods, supported by server.
 */
typedef enum : NSInteger {
    
    /**
     Unknown HTTP request method.
     */
    LDHTTPMethodUnknown = -1,
    
    /**
     GET method.
     */
    LDHTTPMethodGET,
    
    /**
     HEAD method.
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
 A class that represents HTTP requests.
 */
@interface LDHTTPRequest : NSObject

///=====================
/// @name Initialization
///=====================

- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes object with specified http message object. Usually you don't need to use this methods because LDHTTPServer calls it for you when parses a request.
 
 @return An initialized object.
 */
- (instancetype)initWithMessage:(CFHTTPMessageRef)httpMessage;

///=================================
/// @name Getting Request Parameters
///=================================

/**
 HTTP method of request.
 */
@property (nonatomic, assign, readonly) NSInteger method;

/**
 Request URI.
 */
@property (nonatomic, strong, readonly) NSURL *uri;

/**
 HTTP version.
 */
@property (nonatomic, strong, readonly) NSString *httpVersion;

/**
 @brief Contains arguments, if passed with request.
 */
@property (nonatomic, strong, readonly) NSDictionary *arguments;

/**
 Parses arguments from relative path. Usually you don't need to call this method, because LDHTTPRequest object uses it itself.
 
 @param uri Relative path that contains parameters.
 
 @return Dictionary that contains parsed parameters with values as a key-value storage.
 */
- (NSDictionary *)parseArgumentsFromURL:(NSString *)uri;

/**
 Request headers.
 */
@property (nonatomic, strong, readonly) NSDictionary *HTTPHeaders;

/**
 Access to pointed HTTP header.
 
 @param header The name of HTTP header, e.g. @"User-Agent".
 
 @return The value of the header. Returns nil if there is no header or
 no value.
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

@end
