//
//  LDHTMLTemplate.m
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "LDHTMLTemplate.h"


@implementation LDHTMLTemplate

+ (NSString *)renderTemplateAtPath:(NSString *)filepath withParameters:(NSDictionary *)parameters {
    __block NSString *template = [NSString stringWithContentsOfFile:filepath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    if (!template) {
        return nil;
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *token = [NSString stringWithFormat:@"{{ %@ }}", key];
        template = [template stringByReplacingOccurrencesOfString:token
                                                       withString:obj];
    }];
    
    return template;
}

@end
