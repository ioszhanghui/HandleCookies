//
//  WKProcessPool+SharedProcessPool.h
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/17.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKProcessPool (SharedProcessPool)
/*内容加载池*/
@property(readonly,class,nonatomic,strong) WKProcessPool * sharedProcessPool;

@end

NS_ASSUME_NONNULL_END
