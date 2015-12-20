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
 This class implements HTTP server.
 */
@interface LDHTTPServer : LDTCPServer <LDTCPServerDelegate>

/**
 Sets an request handler for HTTP requests at specified path. When server accepts new HTTP request, it looks for request handlers, who is subscribed to requested path, and passes request to it.
 
 @param requestHandler Request handler, that handles HTTP requests.
 @param path A path where handler expects to recieve requests.
 */
- (void)addRequestHandler:(LDHTTPRequestHandler *)requestHandler forPath:(NSString *)path;

@end
