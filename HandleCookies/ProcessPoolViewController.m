//
//  TwoViewController.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/17.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "ProcessPoolViewController.h"
#import <WebKit/WebKit.h>
#import "WKProcessPool+SharedProcessPool.h"

@interface ProcessPoolViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * testView;
@end

@implementation ProcessPoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testWKWebView];
}

/*共享进程池*/
-(void)testWKWebView{
    
    WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
    webViewConfig.processPool = [WKProcessPool sharedProcessPool];
    
    CGRect frame = self.view.bounds;
    self.testView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:webViewConfig];
    [self.view addSubview:self.testView];
    self.testView.navigationDelegate = self;
    self.testView.allowsBackForwardNavigationGestures= YES;
    
    NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString: @"https://d.m.gome.com.cn/storeowner?storeCode=A007"] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:60];
    [self.testView loadRequest:mutableRequest];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
