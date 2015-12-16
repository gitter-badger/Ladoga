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


@protocol LDHTTPServerDelegate <NSObject>
@required
- (LDHTTPResponse *)processRequest:(LDHTTPRequest *)request;
@end


@interface LDHTTPServer : LDTCPServer <LDTCPServerDelegate>

@property (nonatomic, weak, readwrite) id <LDHTTPServerDelegate> httpServerDelegate;
@end
