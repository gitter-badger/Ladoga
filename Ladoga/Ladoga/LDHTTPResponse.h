//
//  LDHTTPResponse.h
//  Ladoga
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LDHTTPResponse : NSObject

@property (nonatomic, assign, readonly) CFHTTPMessageRef httpMessage;

@property (nonatomic, assign, readwrite) NSUInteger code;
@property (nonatomic, strong, readwrite) NSString *body;

- (NSString *)valueForHTTPHeader:(NSString *)header;
- (void)addValue:(NSString *)value forHTTPHeader:(NSString *)header;
- (void)deleteHTTPHeader:(NSString *)header;

+ (instancetype)internalServerErrorResponse;
@end
