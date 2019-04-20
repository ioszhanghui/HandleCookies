//
//  ModelLiu.h
//  用于字典转模型的工具类
//  主要功能包括：通过字典转换成对应的模型
//  转模型过程中可以处理一些个性化需求
//  比如：替换字典 key 值，并与指定的属性名对应
//       默认值处理等
//  效率和内存使用都有良好的表现
//
//  Created by liukun on 15/6/20.
//  Copyright © 2015年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 引入封装属性类前声明
@class ModelLiuProperty;


/*!
 *  @author liukun, 15-06-20
 *
 *  @brief  字典转模型协议
 *
 *  @since  4.1.0
 */
@protocol GMPModelLiu <NSObject>

/*!
 *  @author liukun, 15-06-20
 *
 *  @brief  字典转模型协议方法
 *
 *  @param  dict 转模型的字典
 *
 *  @since  4.1.0
 */
- (void)toSelf:(NSDictionary *)dict;

@optional

/*!
 *  @author liukun, 15-06-22
 *
 *  @brief  将属性名换为其他key去字典中取值
 *
 *  @return key 属性名，value 字典中取值用的key
 *
 *  @since  4.1.0
 */
+ (NSDictionary *)replaceKeyWithPropertyName;

/*!
 *  @author 柳坤
 *
 *  @brief 实现该方法，可以设置不需要赋值的属性
 *
 *  @return 返回需要忽略的属性
 */
- (NSSet *)ignoreProperties;

/*!
 *  @author 柳坤
 *
 *  @brief 实现该方法，当返回YES时，可以忽略字典中不包含，但是模型中有的属性的值。NO和不实现效果一致，默认不忽略
 *
 */
- (BOOL)ignoreKeysNotContainInDict;

@end

/*!
 *  @author liukun, 15-06-20
 *
 *  @brief  字典转模型工具类
 *
 *  @since  4.1.0
 */
@interface ModelLiu : NSObject <GMPModelLiu>


@end


@interface SBModel : ModelLiu

/// 是否成功
@property (nonatomic, copy) NSString *isSuccess;

/// jsessionId
@property (nonatomic, copy) NSString *jsessionId;

/// 回话是否过期
@property (nonatomic, copy) NSString *isSessionExpired;

/// 是否可用
//@property (nonatomic, copy) NSString *isActivated;

/// 服务器时间
@property (nonatomic, copy) NSString *serverTime;

/// 方便标记model状态，非接口字段
@property (nonatomic, assign) BOOL gm_isSelect;


@end
