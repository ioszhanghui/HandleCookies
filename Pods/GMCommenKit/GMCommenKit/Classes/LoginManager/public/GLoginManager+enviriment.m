//
//  GLoginManager+enviriment.m
//  GLoginManagerTest
//
//  Created by Gome on 2019/2/21.
//  Copyright © 2019年 lijian. All rights reserved.
//

#import "GLoginManager+enviriment.h"

@implementation GLoginManager (enviriment)
///显示切换环境界面
+(void)setupSwitchEnvoriment{
    
    #ifdef DEBUG
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GLoginManager setupSwitchEnvorimentView];
        });
    #endif
    
}
@end
