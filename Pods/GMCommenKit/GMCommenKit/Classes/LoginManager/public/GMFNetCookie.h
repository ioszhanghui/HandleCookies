//
//  GMFNetCookie.h
//  GomeNetBase
//
//  Created by 贾旭周 on 15/7/6.
//  Copyright (c) 2015年 gm-iMac-iOS-03. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class ASIHTTPRequest;


@interface GMFNetCookie : NSObject



#pragma mark - 退出APP时，保存cookie到本地
/*!
 *  @author tangbinqi, 15-01-05 18:01:49
 *
 *  @brief  APP退出时，保存cookie至本地
 *
 *  @since 4.0.6
 */
+ (void)saveCookiesForUserDefaults;


#pragma mark - APP启动时，从useDefaults读取cookie,保存到 sharedHTTPCookieStorage
/*!
 *  @author tangbinqi, 15-01-05 18:01:05
 *
 *  @brief  APP启动时，从useDefaults读取cookie,保存到 sharedHTTPCookieStorage
 *
 *  @since 4.0.6
 */
+ (void)getCookieFromeUserDefaults;





#pragma mark - 给传入的ASIHTTPRequest对象设置cookie
/*!
 *  @author tangbinqi, 15-01-05 17:01:46
 *
 *  @brief  给request请求设置cookie
 *
 *  @param request
 *
 *  @since 4.0.6
 */
//+ (void)setCookiesWithRequest:(ASIHTTPRequest *)request;


#pragma mark - （退出登录时）清除长登录使用的cookie
/*!
 *  @author tangbinqi, 15-01-05 18:01:26
 *
 *  @brief  退出登录时,清除长登录使用的cookie
 *
 *  @since 4.0.6
 */
+ (void)cleanCookie;


/// 网络请求回来过滤保存cookie到缓存和本地
/*!
 *  @author jiaxuzhou, 15-04-15 10:57
 *
 *  @brief 网络请求回来过滤保存cookie到缓存和本地
 *
 *  @since 4.0.9
 */
+ (void)getReqCookDic:(NSArray *)aryCookie;

/// 获取混存cookie
/*!
 *  @author jiaxuzhou, 15-04-15 10:57
 *
 *  @brief 获取混存cookie
 *
 *  @since 4.0.9
 */
+ (NSArray *)getAllCookiesSendReq;

/// 按域名删除cookie
/*!
 *  @author jiaxuzhou, 15-04-18 11:22
 *
 *  @brief 按域名删除cookie
 *
 *  @since 4.0.9
 */
+ (void)deleteCookieByDomain:(NSString *)domain;

/*!
 @author JiaXuZhou, 15-09-02 17:09:05
 
 @brief  从cookie中获取SCN
 
 @return SCN
 
 @since v4.1.5
 */
+ (NSString *)getSCNFromCookie;




+ (NSString *)getUserIDFromCookie;
@end
