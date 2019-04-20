//
//  AppDelegate.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/09.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GLoginManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    
    //登录SDK的初始化
//    [GLoginManager initEnviriment];
//    //自动登录
//    [GLoginManager autoLogin:^(BOOL isSucess) {
//        if (isSucess) {
//            //调用登录
//            /*IM*/
//            NSLog(@"autoLoginSuccess");
//        }else{
//            NSLog(@"autoLoginFailure");
//        }
//    }];
//    
//    [self printCookie];
    
    return YES;
}

-(void)printCookie{
    
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [[cookieStorage cookies]enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"didFinishLaunchingWithOptions**%@",[obj properties]);
        UIPasteboard * paste =[[UIPasteboard alloc]init];
        paste.string = [self jsonStringEncoded:[obj properties]];
    }];
}
- (NSString *)jsonStringEncoded:(NSDictionary*)json {
    if ([NSJSONSerialization isValidJSONObject:json]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}
@end
