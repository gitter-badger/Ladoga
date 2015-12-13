//
//  MyServerExample.h
//  LadogaExample
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../Ladoga/Ladoga/Ladoga.h"


@interface MyServerExample : NSObject <LDHttpServerDelegate>

- (void)start;
@end
