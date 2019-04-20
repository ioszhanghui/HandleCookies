//
//  WKProcessPool+SharedProcessPool.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/17.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "WKProcessPool+SharedProcessPool.h"

@implementation WKProcessPool (SharedProcessPool)
+(WKProcessPool *)sharedProcessPool{
    static dispatch_once_t onceToken;
   static WKProcessPool * processPool = nil;
    dispatch_once(&onceToken, ^{
        processPool = [[WKProcessPool alloc]init];
    });
    return processPool;
}
@end
