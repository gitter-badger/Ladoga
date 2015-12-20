//
//  LDHTMLTemplate.h
//  Ladoga
//
//  Created by Alexander Perechnev on 19.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Class that implements template rendering.
 */
@interface LDHTMLTemplate : NSObject

/**
 Renders template to an HTML page. Call this method to render your template and get an HTML page.
 
 @param filepath Full path to template file.
 @param parameters Template parameters.
 
 @return Rendered template as a string, that represents HTML page.
 */
+ (NSString *)renderTemplateAtPath:(NSString *)filepath
                    withParameters:(NSDictionary *)parameters;

@end
