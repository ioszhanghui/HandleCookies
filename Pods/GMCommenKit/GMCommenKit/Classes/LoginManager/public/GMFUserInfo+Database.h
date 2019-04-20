//
//  GMFUserInfo+Database.h
//  Pods
//
//  Created by lijian on 2017/7/24.
//
//

#import <Foundation/Foundation.h>

extern BOOL g_isLoadingUserInfoData;

@class GMFUserInfo;


@interface GMFUserInfoDatabase : NSObject


#pragma mark - ******************************** 用户信息数据库 *******************************


+ (NSMutableDictionary *)dictionaryFromModel:(Class) modelClass superKey:(NSString *) superKey;


//TODO: 保存用户信息中的string类型数据到GMFUserInfo_Table表中
+ (BOOL)saveUserInfoToFeild:(NSString *)strFeild stringValue:(NSString *) strValue;

//TODO: 保存用户信息中的BOOL类型数据到GMFUserInfo_Table表中
+ (BOOL)saveUserInfoToFeild:(NSString *)strFeild BOOLValue:(BOOL) boolValue;

//TODO: 保存用户信息中的long long类型数据到GMFUserInfo_Table表中
+ (BOOL)saveUserInfoToFeild:(NSString *)strFeild IntegerValue:(long long) integerValue;





+ (void)loadUserInfoTo:(GMFUserInfo *) userInfoObject finishBlock:(void(^)(BOOL isLogined)) finishblock;

//TODO:删除表中行
+ (BOOL)deleteUserInfoTable;



@end
