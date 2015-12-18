//
//  Ladoga.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

FOUNDATION_EXPORT double LadogaVersionNumber;

FOUNDATION_EXPORT const unsigned char LadogaVersionString[];

#import <Ladoga/LDTCPServer.h>
#import <Ladoga/LDHTTPServer.h>
#import <Ladoga/LDHTTPRequest.h>
#import <Ladoga/LDHTTPResponse.h>
