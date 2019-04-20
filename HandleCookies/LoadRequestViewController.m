//
//  LoadRequestViewController.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/20.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "LoadRequestViewController.h"
#import <WebKit/WebKit.h>

@interface LoadRequestViewController ()
@property(nonatomic,strong)WKWebView * wkWebView;
@property(nonatomic,strong)NSURL * relativeURL;
@end

@implementation LoadRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*ReadAccessToURL 访问不同路径下的内容*/
-(void)loadReadAccessToURL{
    
/*

 NSString *pathA = "file:///path/to/abc/dirA/A.html";//需要加载的资源路径1
 NSString *pathB = "file:///path/to/abc/dirB/B.html";//需要加载的资源路径2
 NSString *pathC = "file:///path/to/abc/dirC/C.html";//需要加载的资源路径3
 
 NSURL *url = [NSURL fileURLWithPath:pathA];
 
 NSURL *readAccessToURL = [[url URLByDeletingLastPathComponent] URLByDeletingLastPathComponent];
  // readAccessToURL == "file:///path/to/abc/"[self.wk_webview loadFileURL:url allowingReadAccessToURL:readAccessToURL];
 // then you want load  pathB
 url = [NSURL fileURLWithPath:pathB];
 // this will work fine
 [self.wk_webview loadFileURL:url allowingReadAccessToURL:readAccessToURL];
 */
    
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL * filePath = [NSURL fileURLWithPath:[directoryPath stringByAppendingPathComponent:@"dirA/test.html"]];
    NSURL * accessToURL = [[filePath URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] ;
    [self.wkWebView loadFileURL:filePath allowingReadAccessToURL:accessToURL];
    self.relativeURL = accessToURL;
}

/*Request 方式加载*/
-(void)loadRequest{
    /*远程*/
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://d.m.gome.com.cn"]]];
    //本地
    //[self.wkWebView loadRequest:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"test.html" ofType:nil]]];
}

/*加载 HTML 字符串*/
-(void)loadHTMLString{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString * htmlContent = [[NSString alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:(NSUTF8StringEncoding) error:nil];
    [self.wkWebView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
}

/*通过Data方式加载*/
-(void)loadData{
    
    /*加载本地*/
    //    NSString * path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    //    NSData * fileData = [[NSData alloc]initWithContentsOfFile:path];
    //    [self.wkWebView loadData:fileData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
    
    /*加载网络的*/
    NSData * fileData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"https://d.m.gome.com.cn"]];
    [self.wkWebView loadData:fileData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"https://d.m.gome.com.cn"]];
}
@end
