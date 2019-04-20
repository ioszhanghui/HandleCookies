//
//  GMDLoginViewDelegate.h
//  GMAFNetworking
//
//  Created by lijian on 2018/4/12.
//

#import <Foundation/Foundation.h>

@protocol GMDLoginViewDelegate <NSObject>

@optional

/// 登录成功的消失时调用
- (void)gmdOp_loginSuccessAndWillDismiss;
/// 未登录时
- (void)gmdOp_noLoginAndCancel;

/// 点击返回按钮
- (void)loginClickBackButton;

@end


