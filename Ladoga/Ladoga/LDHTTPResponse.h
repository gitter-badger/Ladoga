//
//  LDHTTPResponse.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDHTMLTemplate.h"


static const NSInteger LD_HTTP_RESPONSE_CODE_CONTINUE = 100;
static const NSInteger LD_HTTP_RESPONSE_CODE_SWITCHING_PROTOCOLS = 101;
static const NSInteger LD_HTTP_RESPONSE_CODE_OK = 200;
static const NSInteger LD_HTTP_RESPONSE_CODE_CREATED = 201;
static const NSInteger LD_HTTP_RESPONSE_CODE_ACCEPTED = 202;
static const NSInteger LD_HTTP_RESPONSE_CODE_NON_AUTHORITATIVE_INFORMATION = 203;
static const NSInteger LD_HTTP_RESPONSE_CODE_NO_CONTENT = 204;
static const NSInteger LD_HTTP_RESPONSE_CODE_RESET_CONTENT = 205;
static const NSInteger LD_HTTP_RESPONSE_CODE_PARTIAL_CONTENT = 206;
static const NSInteger LD_HTTP_RESPONSE_CODE_MULTIPLE_CHOICES = 300;
static const NSInteger LD_HTTP_RESPONSE_CODE_MOVED_PERMANENTLY = 301;
static const NSInteger LD_HTTP_RESPONSE_CODE_FOUND = 302;
static const NSInteger LD_HTTP_RESPONSE_CODE_SEE_OTHER = 303;
static const NSInteger LD_HTTP_RESPONSE_CODE_NOT_MODIFIED = 304;
static const NSInteger LD_HTTP_RESPONSE_CODE_USE_PROXY = 305;
static const NSInteger LD_HTTP_RESPONSE_CODE_TEMPORARY_REDIRECT = 307;
static const NSInteger LD_HTTP_RESPONSE_CODE_BAD_REQUEST = 400;
static const NSInteger LD_HTTP_RESPONSE_CODE_UNAUTHORIZED = 401;
static const NSInteger LD_HTTP_RESPONSE_CODE_PAYMENT_REQUIRED = 402;
static const NSInteger LD_HTTP_RESPONSE_CODE_FORBIDDEN = 403;
static const NSInteger LD_HTTP_RESPONSE_CODE_NOT_FOUND = 404;
static const NSInteger LD_HTTP_RESPONSE_CODE_METHOD_NOT_ALLOWED = 405;
static const NSInteger LD_HTTP_RESPONSE_CODE_NOT_ACCEPTABLE = 406;
static const NSInteger LD_HTTP_RESPONSE_CODE_PROXY_AUTHENTICATION_REQUIRED = 407;
static const NSInteger LD_HTTP_RESPONSE_CODE_REQUEST_TIMEOUT = 408;
static const NSInteger LD_HTTP_RESPONSE_CODE_CONFLICT = 409;
static const NSInteger LD_HTTP_RESPONSE_CODE_GONE = 410;
static const NSInteger LD_HTTP_RESPONSE_CODE_LENGTH_REQUIRED = 411;
static const NSInteger LD_HTTP_RESPONSE_CODE_PRECONDITION_FAILED = 412;
static const NSInteger LD_HTTP_RESPONSE_CODE_REQUEST_ENTITY_TOO_LARGE = 413;
static const NSInteger LD_HTTP_RESPONSE_CODE_REQUEST_URI_TOO_LARGE = 414;
static const NSInteger LD_HTTP_RESPONSE_CODE_UNSUPPORTED_MEDIA_TYPE = 415;
static const NSInteger LD_HTTP_RESPONSE_CODE_REQUEST_RANGE_NOT_SATISFIABLE = 416;
static const NSInteger LD_HTTP_RESPONSE_CODE_EXPECTATION_FAILED = 417;
static const NSInteger LD_HTTP_RESPONSE_CODE_INTERNAL_SERVER_ERROR = 500;
static const NSInteger LD_HTTP_RESPONSE_CODE_NOT_IMPLEMENTED = 501;
static const NSInteger LD_HTTP_RESPONSE_CODE_BAD_GATEWAY = 502;
static const NSInteger LD_HTTP_RESPONSE_CODE_SERVICE_UNAVAILABLE = 503;
static const NSInteger LD_HTTP_RESPONSE_CODE_GATEWAY_TIMEOUT = 504;
static const NSInteger LD_HTTP_RESPONSE_CODE_HTTP_VERSION_NOT_SUPPORTED = 505;


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
 @brief Initialized object with specified HTTP response code.
 
 @discussion Keep it in mind that this initializer also initializes body with predefined
    template.
 
 @param code HTTP response status code.
 
 @return Returns an initialized object.
 */
- (instancetype)initWithCode:(NSInteger)code;

/**
 @brief Value for HTTP header.
 
 @param header Header name.
 
 @return Return header value or nil if header doesn't exist..
 */
- (NSString *)valueForHTTPHeader:(NSString *)header;

/**
 @brief Adds new header to response.
 
 @discuss Adds new header or set new value if header already exists.
 
 @param value Header value.
 @param header Header name.
 */
- (void)addValue:(NSString *)value forHTTPHeader:(NSString *)header;

/**
 @brief Deletes header.
 
 @param header Header name.
 */
- (void)deleteHTTPHeader:(NSString *)header;

@end
