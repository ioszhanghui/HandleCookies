//
//  GMBLoginManager.h
//  GomeEShop
//
//  Created by yuwuchao on 15/5/11.
//  Copyright (c) 2015年 Gome. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GMDLoginViewDelegate.h"

///登录成功通知
extern NSString *const GMFLoginSuccessNotification ;

///退出登录通知
extern NSString *const GMFLogoutSuccessNotification ;


@interface GLoginManager : NSObject


/*
    @brief  初始化GLoginManager环境。需要在application: didFinishLaunchingWithOptions:
            函数中调用
 */
+(void) initEnviriment;


/*
    @brief 弹出登录界面（老版本功能）
    @param CurrentVC  当前VC 不可空
    @param delegate   登录代理（成功和失败会回调）可空
    @param dicParam   参数，预留字段，可空
    @param animatedBlock  present 登录VC后的回调
 */
+ (void)login:(id)CurrentVC
     delegate:(id<GMDLoginViewDelegate>)delegate
    parameter:(NSDictionary *)dicParam
   completion: (void (^)(void))animatedBlock;

/*
     @brief 弹出登录界面
     @param CurrentVC  当前VC 不可空
     @param dicParam   参数，预留字段，可空
     @param loginSuccessBlock  登录成功回调
 */
+ ( void )login:(id)CurrentVC
      parameter:(NSDictionary *)dicParam
   successBlock:(void (^)(void))loginSuccessBlock;


/*
     @brief 弹出登录界面
     @param CurrentVC           当前VC 不可空
     @param dicParam            参数，预留字段，可空
     @param loginSuccessBlock   登录成功回调
     @param loginFailBlock      登录失败回调
 */
+ ( void )login:(id)CurrentVC
      parameter:(NSDictionary *)dicParam
   successBlock:(void (^)(void))loginSuccessBlock
    failedBlock:(void (^)(void))loginFailBlock;


///退出登录
+ (void)loginOut;


///自动登录 
+ (void)autoLogin:(void(^)(BOOL)) finishBlock;


/*
     @brief 第三方登录回调，在application: openURL:(NSURL *)url sourceApplication: annotation:中调用
     @param CurrentVC           当前VC 不可空
     @param dicParam            参数，预留字段，可空
     @param loginSuccessBlock   登录成功回调
     @param loginFailBlock      登录失败回调
 */
+ (BOOL) handleUrl:(NSURL *)url;


/*
 @brief 情况keychan中保存的登录相关的秘钥
 */
+ (void) cleanLoginKeychain;


///显示切换环境界面
+ (void) setupSwitchEnvorimentView;


@end
