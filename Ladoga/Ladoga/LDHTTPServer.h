//
//  LDHttpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDTCPServer.h"
#import "LDHTTPRequest.h"
#import "LDHTTPResponse.h"


typedef enum : NSInteger {
    LDHTTPMethodUnknown = -1,
    LDHTTPMethodOPTIONS,
    LDHTTPMethodGET,
    LDHTTPMethodHEAD,
    LDHTTPMethodPOST,
    LDHTTPMethodPUT,
    LDHTTPMethodPATCH,
    LDHTTPMethodDELETE,
    LDHTTPMethodTRACE,
    LDHTTPMethodCONNECT
} LDHTTPMethod;


/**
 @brief Delegate that handles new requests.
 
 @discussion You have to implement this protocol and set it to server's httpServerDelegate 
 to handle HTTP requests.
 */
@protocol LDHTTPServerDelegate <NSObject>
@required
- (LDHTTPResponse *)processRequest:(LDHTTPRequest *)request;
@end


/**
 @brief This class implements HTTP server.
 
 @discussion Use this class to build an HTTP server.
 */
@interface LDHTTPServer : LDTCPServer <LDTCPServerDelegate>

/**
 @brief An delegate, that handles clients' requests.
 
 @discussion You must set this property to handle requests.
 */
@property (nonatomic, weak, readwrite) id <LDHTTPServerDelegate> httpServerDelegate;
@end
