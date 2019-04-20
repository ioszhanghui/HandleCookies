//
//  GMFUserInfo+Function.h
//  Pods
//
//  Created by lijian on 2017/1/20.
//
//

#import "GMFUserInfo.h"

@interface  GMFUserInfo(Function)

///显示登录界面(通用方法 )
- (void) showLoginViewAtCurrentVC:(UIViewController*)vc finishBlock:(LoginFinishBlock) finishBlock;


///特殊方法，一般 很少使用，
- (void) showLoginViewAtCurrentVC:(UIViewController*)vc
                         paramDic:(NSDictionary *) dicParam
                      finishBlock:(LoginFinishBlock) finishBlock;


///获取用户信息
-(void)req_URL_profileABInfo:(void (^)(BOOL isSuccess))block;

//-(void) getDetailUserInfo:(GetUserInfoFinishBlock)finishBlock;

-(void)req_URL_Worth:(void (^)(BOOL isSuccess))block;
-(void)req_URL_Expert:(void (^)(BOOL isSuccess))block;

///店铺状态
-(void)req_URL_ShopStatusWithResultBlock:(void (^)(BOOL isSuccess))block;

///退出登录
- (void)logOut;

///登录成功后调用
-(BOOL) login;

///登录成功后获取用户信息
-(void) getUserInfoIsProfileA:(BOOL) isProfileA;


///使用网络返回的数据  更新GMFUserInfo
- (void)updateUserInfo:(NSDictionary *)dictSouce;

///将用户信息转化为字典
- (NSDictionary *)getUserInfoDict;

///im的用户id
-(NSString*)imId;

-(NSString*)onlineUserId;

///店铺的类型
-(NSInteger)shopType;



@end
