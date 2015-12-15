//
//  LDHttpServer.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDTcpServer.h"
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


@protocol LDHttpServerDelegate <NSObject>
@required
- (LDHTTPResponse * _Nonnull)processRequest:(LDHTTPRequest * _Nonnull)request;
@end


@interface LDHttpServer : LDTcpServer <LDTcpServerDelegate>

@property (nonatomic, weak, readwrite) id <LDHttpServerDelegate> httpServerDelegate;
@end
