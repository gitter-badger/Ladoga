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
#import "LDHTTPRequestHandler.h"


/**
 @brief This class implements HTTP server.
 
 @discussion Use this class to build an HTTP server.
 */
@interface LDHTTPServer : LDTCPServer <LDTCPServerDelegate>


/**
 */
- (void)addRequestHandler:(LDHTTPRequestHandler *)requestHandler forPath:(NSString *)path;

@end
