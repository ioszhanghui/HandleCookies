
//
//  PostViewController.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/20.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "PostViewController.h"
#import <WebKit/WebKit.h>

@interface PostViewController ()
@property(nonatomic,strong)WKWebView * wkWebView;
@property(nonatomic,assign)BOOL  isOpen;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)testPost{
    
    WKWebViewConfiguration * wkwebViewConfig = [[WKWebViewConfiguration alloc]init];
    WKPreferences * prefence =[WKPreferences new];
    prefence.javaScriptEnabled = YES;
    prefence.javaScriptCanOpenWindowsAutomatically = YES;
    wkwebViewConfig.preferences = prefence;

    
    WKWebView * myWeb = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkwebViewConfig];
    self.wkWebView = myWeb;    // 设置代理来确定什么时候网页文件加载完成
    self.isOpen = YES;
    [self.view addSubview:myWeb];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString * html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"test.html" ofType:nil];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [self.wkWebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:filePath]];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    if (@available(iOS 11.0, *)) {
        
        [[WKWebsiteDataStore nonPersistentDataStore].httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull httpCookies) {
            
            [httpCookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"properties**%@",[obj properties]);
            }];
        }];
        
        NSDate * fireDate = [NSDate dateWithTimeIntervalSinceNow:-3600*24];
        
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:fireDate completionHandler:^{
            
        }];
        
        /*
         [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:[NSSet setWithObjects:WKWebsiteDataTypeDiskCache, nil] forDataRecords:records completionHandler:^{
         
         }];
         */
        [[WKWebsiteDataStore defaultDataStore]fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
            
            
        }];
        [[WKWebsiteDataStore defaultDataStore].httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull httpCookies) {
            
            [httpCookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"properties**%@",[obj properties]);
            }];
        }];
    } else {
        // Fallback on earlier versions
    }
    if (self.isOpen) {
        NSString * dataStr = @"{\"token\":\"cac6af340960485aa334416c8a34ddbf\"}";        // 要访问的地址
        NSDictionary * postData = @{
                                    @"token":@"cac6af340960485aa334416c8a34ddbf",
                                    @"test":@"test"
                                    };

        NSString * url = @"http://192.168.1.8:8000/show_meta/";
        NSString * js = [NSString stringWithFormat:@"my_post(\"%@\", %@)",url,[self jsonStringEncoded:postData]];        // 最后执行JS代码
        [webView evaluateJavaScript:js completionHandler:nil];        // 设置标记确保只执行一次
        self.isOpen = NO;
    }
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
