//
//  GMFUserInfo+Plus.h
//  Pods
//
//  Created by lijian on 2017/1/20.
//
//
#import "SBModel.h"
#import "GMFUserInfo+Database.h"



static BOOL isGMFUserInfoInit = NO;
//#define GMM_NSStringSETSELECTOR(name) \
//-(void)set##[@#name capitalizedString]: (NSString *) value \
//{\
//_##name = value \
//}
#define GMM_Capital (name) #name

#define GMM_NSStringSETSELECTOR(SelName,varName,FeildName) \
-(void)set##SelName: (NSString *) value \
{\
    NSString *strOldValue = _##varName;\
    _##varName = value ;\
    if(!g_isLoadingUserInfoData && ![strOldValue isEqualToString:_##varName] )\
    {\
       [GMFUserInfoDatabase saveUserInfoToFeild:@#FeildName stringValue:value];\
    }\
}


#define GMM_BoolSETSELECTOR(SelName,varName,FeildName) \
-(void)set##SelName: (BOOL) value \
{\
    BOOL oldValue = _##varName;\
    _##varName = value  ;\
    if(!g_isLoadingUserInfoData && oldValue != _##varName)\
    {\
        [GMFUserInfoDatabase saveUserInfoToFeild:@#FeildName BOOLValue:value];\
    }\
}\
-(void) setDB##SelName:(NSNumber*)value\
{\
    _##varName = value.boolValue  ;\
}\


#define GMM_NSIntegerSETSELECTOR(SelName,varName,FeildName) \
-(void)set##SelName: (NSInteger) value \
{\
    NSInteger oldValue = _##varName;\
    _##varName = value ;\
    if(!g_isLoadingUserInfoData && oldValue != _##varName)\
    {\
       [GMFUserInfoDatabase saveUserInfoToFeild:@#FeildName IntegerValue:value];\
    }\
}\
-(void) setDB##SelName:(NSNumber*)value\
{\
    _##varName = value.longLongValue  ;\
}\

typedef void (^LoginFinishBlock)(BOOL isSuccess);

typedef void (^GetUserInfoFinishBlock)(BOOL isSuccess);

//登录成功通知
extern NSString *const GMFLoginSuccessNotification;

//退出登录成功通知
extern NSString *const GMFLogoutSuccessNotification;


typedef NS_ENUM(NSInteger, GME_ImgDensity)
{
    /// 智能模式
    GME_ImgDensitySmart = 1,
    
    /// 高质量
    GME_ImgDensityHighQuality,
    
    /// 普通模式
    GME_ImgDensityNormal
};

@class GMFUserExtendInfo;


@interface GMFUserInfo_Plus : SBModel

///1.会员推荐人id
@property(nonatomic, strong) NSString * membershipRefereeId;

///2.商家推荐人ID
@property(nonatomic, strong) NSString * xpopRefereeId;

///3.用户角色
@property(nonatomic, strong) NSString * roleType;

///4.用户注册时间
@property(nonatomic, strong) NSString * registerTime;

///5.自己推荐码
@property(nonatomic, strong) NSString * referralCode;

///6.用户签名
@property(nonatomic, strong) NSString * userSign;

///7.用户推荐码
@property(nonatomic, strong) NSString * referee;

///扩展信息
@property(nonatomic, strong)GMFUserExtendInfo * extendInfo;

///经度
@property (nonatomic, assign) NSInteger latitude;

///纬度
@property (nonatomic, assign) NSInteger longitude;

/// 社交圈子和话题审核的参数，严禁修改 🚫🚫🚫
@property (nonatomic, assign) BOOL isPushFirst;


///IMToken
@property(nonatomic, strong) NSString *imToken;

///这个是Plus 的userID
@property(nonatomic,assign) long long userId;

#pragma mark- 第三方相关
@property (nonatomic, strong) NSString *snsUserId;

@property (nonatomic, strong) NSString *snsAccessToken;

@property (nonatomic, strong) NSString *whereFrom;


- (void)clearPlusUserInfo;
@end



@interface GMFUserExExpertCategory : SBModel

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger expertCategoryId;

-(void)clearUserExExpertCategory;
@end




/// 扩展信息中的 达人
@interface GMFUserExExpert : SBModel

@property(nonatomic,assign)BOOL  isExpert;               //是否达人
@property(nonatomic,assign)int64_t userId;             //用户ID
@property(nonatomic,assign)NSInteger auditStatus;        //达人审核状态：0表示待审核，1表示审核

@property(nonatomic,copy)NSString *expertType;          //达人类型："normal",普通(平台)达人；"contracted",签约达人
@property(nonatomic,strong)GMFUserExExpertCategory *category;     //达人分类（ID，名称）

@property(nonatomic,copy)NSString *url;


-(void)clearUserExExpert;
@end



/// 扩展信息中的 店铺信息
@interface GMFUserExShop :SBModel


@property(nonatomic,assign)long long shopId;            //店铺Id
@property(nonatomic,assign)NSInteger backgroundIndex;   //店铺背景编号
@property(nonatomic,copy)NSString *name;                //店铺名
@property(nonatomic,copy)NSString *icon;                //店铺logo
@property(nonatomic,copy)NSString *desc;                //店铺描述
@property(nonatomic,copy)NSString *type;                //店铺类型 mShop-美店,xpop-商户
@property(nonatomic,copy)NSString *url;                 //店铺链接URL
@property(nonatomic,strong)NSMutableArray *mainCategoryNames;   //店铺类目
@property(nonatomic,copy)NSString *strMainCategoryNames; // 店铺类目，需要单独进行数组转换

@property (nonatomic, assign) NSInteger isStaff;//是否员工
@property (nonatomic, assign) NSInteger isStar;//是否明星
@property (nonatomic, copy) NSString *backgroundUrl;//自定义背景图片url
@property (nonatomic, copy) NSString *storeName;//员工门店名称
@property (nonatomic, copy) NSString *categorys;//员工擅长品类

-(void)clearUserExShop;

@end




/// 扩展信息中的 店铺信息
@interface GMFUserExShopStaus :SBModel

///商家状态(0:未入驻，1：入驻意向：2：已入驻)
@property(nonatomic,assign)NSInteger merchantStatus;

///美店状态(0:未开通，1：已开通)
@property(nonatomic,assign)NSInteger shopStatus;

-(void)clearUserExShopStaus;
@end



/// 财富信息
@interface GMFUserExWorth :SBModel

///优惠券
@property(nonatomic,copy)NSString *youhuiquan;

///美通卡
@property(nonatomic,copy)NSString *meitongka;

///美豆
@property(nonatomic,copy)NSString *meidou;

///国美币
@property(nonatomic,copy)NSString *guomeibi;

///返利
@property(nonatomic,copy)NSString *fanli;

-(void)clearUserExWorth;
@end





///用户的扩展信息
@interface GMFUserExtendInfo :SBModel


@property(nonatomic,strong)GMFUserExShop   *shop;


///店铺状态
@property(nonatomic,strong)GMFUserExShopStaus *exShopStatus;

///财富信息
@property(nonatomic,strong)GMFUserExWorth *worth;

///达人信息
@property(nonatomic,strong)GMFUserExExpert *expert;

///清除扩展信息
-(void)clearExtendInfo;
@end
