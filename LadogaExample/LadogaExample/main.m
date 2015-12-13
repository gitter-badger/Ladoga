//
//  main.m
//  LadogaExample
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyServerExample.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyServerExample *server = [[MyServerExample alloc] init];
        [server start];
    }
    return 0;
}
