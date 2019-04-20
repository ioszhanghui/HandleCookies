//
//  CookieViewController.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/20.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "CookieViewController.h"
#import <WebKit/WebKit.h>

@interface CookieViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * wkWebView;
@end

@implementation CookieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testCookie];
}

-(NSString*)userScriptCookie{
    NSMutableString * cookie = [NSMutableString string];
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * cookieSub = [NSString stringWithFormat:@"document.cookie='%@=%@;path=%@;",obj.name,[obj.value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],obj.path];//domain=%@;
        [cookie appendString:cookieSub];
    }];
    
    return cookie;
}

-(void)testCookie{

    [self storeCookieStorage:[self cookieArr]];
    
    WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
    
    /*第一种 通过UserContent 注入*/      //@"https://d.m.gome.com.cn/storeowner?storeCode=A007"
    // 视频 链接
    WKUserContentController * userContent = [[WKUserContentController alloc]init];
    NSString * cookieScript = [self userScriptCookie];
    WKUserScript * userScript = [[WKUserScript alloc]initWithSource:cookieScript injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
    [userContent addUserScript:userScript];
    webViewConfig.userContentController  =userContent;
    
    
    CGRect frame = self.view.bounds;
    CGSize size = frame.size;
    CGRect webFrame = CGRectMake(0, 0, size.width, size.height/2);
    webFrame = self.view.bounds;
    self.wkWebView = [[WKWebView alloc]initWithFrame:webFrame configuration:webViewConfig];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.allowsBackForwardNavigationGestures= YES;
    [self changeUserAgent];
    
    //  @"https://d.m.gome.com.cn/storeowner?storeCode=A007"
    /*第二种 在请求头里设置 Cookie*/
    // @"http://www.soku.com/m/y/video?q=阿凡达%20片段#loaded"
    NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[@"https://d.m.gome.com.cn" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:60];
    NSString * requestCookie = [self reuestCookie];
    if (requestCookie.length>1) {
        requestCookie = [requestCookie substringToIndex:requestCookie.length-1];
    }
    [mutableRequest setValue:requestCookie forHTTPHeaderField:@"Cookie"];
    [self.wkWebView loadRequest:mutableRequest];
    
    /*第三种  在请求头里设置 Cookie*/
    [self wkWebSiteStoreComplete:^{
        NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"] cachePolicy:(NSURLRequestReloadIgnoringCacheData) timeoutInterval:60];
        [self.wkWebView loadRequest:mutableRequest];
    }];
}

-(void)wkWebSiteStoreComplete:(void(^)(void))complete{
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore * httpCookieStore = self.wkWebView.configuration.websiteDataStore.httpCookieStore;
        NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
        if (cookies.count==0) {
            complete? complete():nil;
        }
        [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [httpCookieStore setCookie:obj completionHandler:^{
                if (complete&&[obj isEqual:[cookies lastObject]]) {
                    complete();
                }
            }];
        }];
    } 
}


-(NSString*)reuestCookie{
    NSMutableString * requestCookie = [NSMutableString string];
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * appendCookie = [NSString stringWithFormat:@"%@=%@;",obj.name,obj.value];
        [requestCookie appendString:appendCookie];
    }];
    return requestCookie;
}

-(void)changeUserAgent{
    
    [self.wkWebView setCustomUserAgent:@"gomeshop"];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    userAgent = [userAgent stringByAppendingString:@"GomeShop"];
    userAgent = @"gomeshop";
    NSDictionary * customUserAgent = [NSDictionary dictionaryWithObjectsAndKeys:userAgent,@"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults]registerDefaults:customUserAgent];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.wkWebView setCustomUserAgent:userAgent];
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

/*存储 cookie值*/
-(void)storeCookieStorage:(NSArray*)cookieArr{
    
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    cookieStorage.cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    NSArray * cookiesJson = cookieArr;
    [cookiesJson enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableDictionary * cookisDict = [NSMutableDictionary dictionary];
        [cookisDict setObject:obj[@"Name"] forKey:NSHTTPCookieName];
        [cookisDict setObject:obj[@"Value"] forKey:NSHTTPCookieValue];
        [cookisDict setObject:obj[@"Domain"] forKey:NSHTTPCookieDomain];
        [cookisDict setObject:obj[@"Path"] forKey:NSHTTPCookiePath];

        [cookisDict setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24*5] forKey:NSHTTPCookieExpires];
        [cookisDict removeObjectForKey:NSHTTPCookieDiscard];
        [cookisDict removeObjectForKey:NSHTTPCookieDiscard];
        NSHTTPCookie * httpCookie = [[NSHTTPCookie alloc]initWithProperties:cookisDict];
        [cookieStorage setCookie:httpCookie];
    }];
}



-(NSArray*)cookieArr{
    return @[
             @{
                 @"Domain":@"d.m.gome.com.cn",
                 @"Name":@"route",
                 @"Value":@"0dbe76d330b8e803a1009676bfeefc65",
                 @"Created":@(576471953),
                 @"Path":@"/",
                 @"Discard":@TRUE,
                 },
             @{
                 @"Domain":@".m.gome.com.cn",
                 @"Name":@"gm_sid",
                 @"Value":@"byaok7vocarh6g5m4w4d9lcer8ohz7rb53115554856834",
                 @"Created":@"2019-04-17T17:21:53.120Z",
                 @"Path":@"/",
                 @"Discard":@TRUE,
                 },
             @{
                 @"Domain":@"report.gome.com.cn",
                 @"Name":@"route",
                 @"Value":@"cffc1f8857a5c4b151dae373ad2f5fb5",
                 @"Created":@(576471951),
                 @"Path":@"/",
                 @"Discard":@TRUE,
                 },
             @{
                 @"Expires":@"2019-05-10 03:05:51 +0000",
                 @"Domain":@".gome.com.cn",
                 @"Name":@"global_key",
                 @"Value":@"a4bb6e82799741db8f059608f7163c76",
                 @"Created":@(576471951),
                 @"Path":@"/",
                 },
             @{
                 @"Expires":@"2019-05-10 03:05:51 +0000",
                 @"Domain":@".gome.com.cn",
                 @"Name":@"global_key",
                 @"Value":@"a4bb6e82799741db8f059608f7163c76",
                 @"Created":@(576471951),
                 @"Path":@"/",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Created":@(576408758),
                 @"HttpOnly":@(TRUE),
                 @"Expires":@"2019-04-15 09:32:38 +0000",
                 @"Path":@"/",
                 @"Name":@"SCN",
                 @"Value":@"apsQrhlgqqZjRQ8n5uUlSehCBIWk%2BG9vLXc%2BdlH3o9adF782QpE31KC0c1rMEfJIMM%2BmFIivWWeItviECDQNUp6Guc4mcqS12Rz4JYFGTsI%2BVyNaQn02wg%3D%3D0df16bd291e0d5f5706a4296db1a1794",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Created":@(576408758),
                 @"HttpOnly":@TRUE,
                 @"Expires":@"2019-07-10 09:32:38 +0000",
                 @"Path":@"/",
                 @"Name":@"DYN_USER_ID",
                 @"Value":@"76490485268",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Created":@(576408758),
                 @"HttpOnly":@"TRUE",
                 @"Expires":@"2019-07-10 09:32:38 +0000",
                 @"Path":@"/",
                 @"Name":@"gradeId",
                 @"Value":@"G3",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Created":@(576408758),
                 @"HttpOnly":@(TRUE),
                 @"Expires":@"2019-07-10 09:32:38 +0000",
                 @"Path":@"/",
                 @"Name":@"DYN_USER_CONFIRM",
                 @"Value":@ "apsQrhlgqqZjRQ8n5uUlSehCBIWk%2BG9vLXc%2BdlH3o9adF782QpE31KC0c1rMEfJI1igE6nqN2jH9IK8Wkj5lagiHu1VRPNqUZavUrcpcIHs7WNnz1wUQjA%3D%3Db8d5bb73950dabd4fab530244fb0bf88",
                 },
             @{
                 @"Domain":@"www.v2ex.com",
                 @"Created":@(576471695),
                 @"HttpOnly":@TRUE,
                 @"Expires":@"2019-04-14 03:01:35 +0000",
                 @"Path":@"/",
                 @"Name":@"PB3_SESSION",
                 @"Value":@"2|1:0|10:1554778895|11:PB3_SESSION|40:djJleDoxMDEuMjU0LjI0OC4xNjg6NDk1MjUxNjY=|81140bed718fd51b755f2aa55fa61030b6ecfd3021fa1a1d17b564b65096f64c",
                 },
             @{
                 @"HttpOnly":@TRUE,
                 @"Domain":@"mdapp.mobile.gome.com.cn",
                 @"Created":@(576471954),
                 @"Path":@"/",
                 @"Name":@"JSESSIONID",
                 @"Discard":@TRUE,
                 @"Value":@"E0B3D308684DF4949D4B2EEC353981CC",
                 }];
}

@end
