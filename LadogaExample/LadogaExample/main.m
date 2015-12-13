//
//  main.m
//  LadogaExample
//
//  Created by Alexander Perechnev on 13.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ladoga/Ladoga.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        LDTcpServer *server = [[LDTcpServer alloc] initWithAddress:@"127.0.0.1" andPort:55319];
        [server setAcceptConnectionCallback:^(CFSocketNativeHandle nativeSocketHandle){
            write(nativeSocketHandle, "12345", 5);
        }];
        
        CFRunLoopRef runLoop = CFRunLoopGetMain();
        [server startWithRunLoop:runLoop];
        
        CFRunLoopRun();
    }
    return 0;
}
