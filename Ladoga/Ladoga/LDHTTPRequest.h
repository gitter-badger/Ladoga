//
//  LDHTTPRequest.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LDHTTPRequest : NSObject

@property (nonatomic, assign, readonly) NSInteger method;
@property (nonatomic, strong, readonly) NSString * _Nonnull uri;
@property (nonatomic, strong, readonly) NSString * _Nullable userAgent;

- (instancetype _Nullable)init NS_UNAVAILABLE;

- (instancetype _Nullable)initWithMessage:(CFHTTPMessageRef _Nonnull)httpMessage;
@end
