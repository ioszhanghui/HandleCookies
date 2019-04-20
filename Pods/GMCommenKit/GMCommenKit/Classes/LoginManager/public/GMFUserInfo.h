//
//  GMFUserInfo.h
//  GomeEShop
//
//  Created by 苏 循波 on 14/12/17.
//  Copyright (c) 2014年 Gome. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GMFUserInfo+Plus.h"

@class SBRequest;

@class GMRRefreshUserinfo;

@interface GMFBaseUserInfo : SBModel

/// 是否已登录
@property (nonatomic, assign) BOOL isLogined;

/// 是否正在自动登录
@property (nonatomic, assign) BOOL isAutoLogin;

/// 是否是第三方登录
@property (nonatomic, assign) BOOL isQuickLogin;

///是否隐藏我的国美首页的跳转提示栏（如果关闭，只有用户退出登录，再进入我的国美才显示）
@property (nonatomic, assign) BOOL isMineGomeHiddenTip;

- (void)clearBaseUserInfo;

@end


@interface GMFUserInfo : GMFUserInfo_Plus


/// 返回单例
+ (GMFUserInfo *)shared;

@property (nonatomic, strong) GMFBaseUserInfo *baseInfo;

/// 是否需要弹出登录界面
@property (nonatomic, assign) BOOL isAppearLoginView;

/// 门店登录是否需要验证码
@property (nonatomic, assign) BOOL isNeedCaptchaMenDian;

/// 登录超时后是否更换用户名
@property (nonatomic, assign) BOOL isChangeAccountWhenLoginTimeOut;


/// 记录的最后一个登录三次失败的用户名
@property (nonatomic, copy) NSString *strLastErrorName;

/// 用户登录三次失败后是否使用验证码
@property (nonatomic, assign) BOOL isNeedCaptchaAfter3rdLoginFaild;

/// 用户信息是否有值
@property (nonatomic, assign) BOOL isHaveValue;

/// 是否需要刷新送出礼物的列表页
@property (nonatomic, assign) BOOL isNeedRefreshSendGiftList;

/// 用户显示名称(在模型中判断到底显示哪个名称)
@property (nonatomic, copy) NSString *strShowName;

/// 用户是否是新人
@property (nonatomic, copy) NSString *isNewProfile;

///一账通升级信息
@property (nonatomic, copy) NSString *authorizedMsg;



/*************************   //用户接口(userProfileA)返回的数据 *************************/
/// tuid(登陆标识)
@property (nonatomic, copy) NSString * profileID;

/// 会员登陆名
@property (nonatomic, copy) NSString * loginName;

/// 积分
@property (nonatomic, copy) NSString * points;

/// 美豆
@property (nonatomic, copy) NSString * meidouAmount;

/// 美豆链接
@property (nonatomic, copy) NSString * meidouActivity;

/// 美通卡数量
@property (nonatomic, copy) NSString * mtkcounts;

/// 昵称
@property (nonatomic, copy) NSString * nikeName;

/// 积分(国美线下门店积分)
@property (nonatomic, copy) NSString * storePoints;

/// 账户可用余额
@property (nonatomic, copy) NSString * balance;

/// 账户冻结余额
@property (nonatomic, copy) NSString * balanceAuthorized;

/// 绑定的手机号
@property (nonatomic, copy) NSString * mobile;

/// 绑定的邮箱
@property (nonatomic, copy) NSString * email;

/// 会员等级
@property (nonatomic, copy) NSString * gradeName;

/// 继续消费金额
@property (nonatomic, copy) NSString * upgradeAmount;

/// 会员升级等级
@property (nonatomic, copy) NSString * nextGradeName;

/// 会员头像
@property (nonatomic, copy) NSString * memberIcon;

/// 是否为门店会员
@property (nonatomic, copy) NSString * isStoreMember;

/// 用户类型
@property (nonatomic, copy) NSString * memberType;

/// 企业用户状态
@property (nonatomic, copy) NSString * busiUserStatus;

/// 虚拟账户状态
@property (nonatomic, copy) NSString * virtualAccountStatus;

/// 虚拟账户状态说明
@property (nonatomic, copy) NSString * virtualAccountStatusDesc;

/// 用户积分（线上+门店）
@property (nonatomic, copy) NSString * totalPoint;

/// wap页面url
@property (nonatomic, copy) NSString * url;

/// wap页面显示的文字
@property (nonatomic, copy) NSString * content;

/// wap按钮的图片
@property (nonatomic, copy) NSString * activityImage;

/// 是否激活
@property (nonatomic, copy) NSString *isActivated;

/// 性别
@property (nonatomic, copy) NSString *gender;

/// 出生年月
@property (nonatomic, copy) NSString *birthday;

/// 用户昵称
@property (nonatomic, copy) NSString *userNikeName;

/// 是否设置了生日
@property (nonatomic, copy) NSString *isBirthdaySetupFinally;

///已消费总金额
@property (nonatomic, copy) NSString *consumeAmount;

///年购物天数
@property (nonatomic, copy) NSString *yearShopingDays;

///升级到下一级别需要的购物天数
@property (nonatomic, copy) NSString *upgradeShopingDays;

@property (nonatomic, copy) NSString *gradeImgUrl;

@property (nonatomic,copy)  NSString *isAuthorized;

/// 美店用户绑定门店id
@property (nonatomic,copy)  NSString *storeNo;

/// 门店id对应销售组织id
@property (nonatomic,copy)  NSString *orgNo;
/// 会员俱乐部的url
@property(nonatomic,copy)  NSString *clubUrl;
///个性签名
@property(nonatomic,copy)  NSString *userPersonalSign;

/*************************   安全接口返回的数据 *************************/


/// 账号安全等级
@property (nonatomic, copy) NSString * profileCecurityLevel;  //1弱 、2中 、3 强、默认为弱

/// 登陆密码强度
@property (nonatomic, copy) NSString * passwordStrength;

/// 是否是默认密码
@property (nonatomic, copy) NSString * isDefaultPwd;

/*************************   //用户接口(userProfileB)返回的数据 *************************/
// 待支付(gomePlus)
@property (nonatomic, copy) NSString *waitPayOrderNumDesc;
// 待收货(gomePlus)
@property (nonatomic, copy) NSString * readyConfirmOrderNumDesc;
// 待评价(gomePlus)
@property (nonatomic, copy) NSString * waitEvaluateGoodsNumDesc;


/// 待支付订单数量
@property (nonatomic, copy) NSString * waitPayOrderNum;

/// 待收货确认订单数量
@property (nonatomic, copy) NSString * waitConfirmOrderNum;

///新的待确认收货
@property (nonatomic, copy) NSString * readyConfirmOrderNum;

///我的足迹 数量
@property (nonatomic, copy) NSString * userFootprintsNum;

/// 到货通知数量
@property (nonatomic, copy) NSString * arrGoodsNoticeNum;

/// 降价通知数量
@property (nonatomic, copy) NSString * reduPriceNoticeNum;

/// 待评价商品数量
@property (nonatomic, copy) NSString * waitEvaluateGoodsNum;

/// 未读站内信息数量
@property (nonatomic, copy) NSString * expiringCouponNum;

/// 即将过期的优惠券数量
@property (nonatomic, copy) NSString * waitReadMessageNum;

/// 优惠券数量
@property (nonatomic, copy) NSString * couponNum;

/// 待发货数量
@property (nonatomic, copy) NSString * pendingShipmentOrderNum;

/// 用户商品收藏数量
@property (nonatomic, copy) NSString * favoritesGoodsNum;

/// 用户店铺收藏数量
@property (nonatomic, copy) NSString * favoritesShopsNum;



///内部变量
@property(nonatomic, strong) GMRRefreshUserinfo *reqUserInfo;

///内部变量  财富信息
@property(nonatomic, strong) SBRequest *reqWorth;

///内部变量  达人信息
@property(nonatomic, strong) SBRequest *reqExpert;

///内部变量  店铺状态
@property(nonatomic, strong) SBRequest *reqShopStatus;

@property(nonatomic, strong) dispatch_group_t groupGetUserInfo;

@property(nonatomic, strong) dispatch_semaphore_t semGetUerInfo;

- (void)clearUserInfo;


@end

////示例数据
//"data": {
//    "user": {
//        "birthday": "2008-01-01",
//        "facePicUrl": "https:\/\/i6.meixincdn.com\/v1\/img\/T1zFCTB4dv1RXrhCrK.jpg",
//        "gender": 2,
//        "id": 280667,
//        "isEmailActivated": false,
//        "isMobileActivated": true,
//        "membershipRefereeId": 0,
//        "mobile": "13693068465",
//        "nickname": "LJ",
//        "referralCode": "Xb3QInSb",
//        "registerTime": 1478313997000,
//        "roleType": 3,
//        "xpopRefereeId": 0
//    },
//    "shop": {
//        "backgroundIndex": 1,
//        "icon": "https:\/\/i6.meixincdn.com\/v1\/img\/T1zFCTB4dv1RXrhCrK.jpg",
//        "id": 39743,
//        "name": "LJ的小店",
//        "status": 0,
//        "type": "mShop",
//        "url": "http:\/\/mxwap.gome.cn\/280667\/1_800.jpg",
//        "userId": 280667
//    },
//    "expert": {
//        "isExpert": false
//    },
//    "userItemCollectionQuantity": {
//        "quantity": 1
//    },
//    "userShopCollectionQuantity": {
//        "quantity": 2
//    },
//    "userTopicCollectionQuantity": {
//        "quantity": 1
//    },
//    "sellerEnterStatus": {
//        "status": 3
//    },
//    "attentionQuantity": {
//        "attentionQuantity": 0,
//        "fansQuantity": 0
//    },
//    "userOwnedTopicQuantity": {
//        "ownedTopicQuantity": 1
//    },
//    "userOwnedGroupQuantity": {
//        "ownedGroupQuantity": 6
//    }
