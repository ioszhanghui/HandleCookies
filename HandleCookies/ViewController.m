//
//  ViewController.m
//  HandleCookies
//
//  Created by 小飞鸟 on 2019/04/09.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "GLoginManager.h"
#import "GMFUserInfo.h"
#import "WKProcessPool+SharedProcessPool.h"


@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)WKWebView * wkWebView;

@property(nonatomic,assign)BOOL isOpen;

@property(nonatomic,strong)NSURL * relativeURL;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * exampleList;

@end

@implementation ViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(NSMutableArray *)exampleList{
    
    if (!_exampleList) {
        _exampleList = [NSMutableArray arrayWithObjects:@"Cookie注入", @"ProcessPool共享",@"加载方式",@"Post请求",nil];
    }
    return _exampleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testPost];
//    [self testCookie];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.exampleList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self.exampleList objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
     //cookie注入
        [self.navigationController pushViewController:[NSClassFromString(@"CookieViewController") new] animated:YES];
    }else if (indexPath.row==1){
        //共享线程池
        [self.navigationController pushViewController:[NSClassFromString(@"ProcessPoolViewController") new] animated:YES];
    }else if (indexPath.row==2){
        //加载方式
     [self.navigationController pushViewController:[NSClassFromString(@"LoadRequestViewController") new] animated:YES];
    }else if (indexPath.row==3){
        //加载方式
        [self.navigationController pushViewController:[NSClassFromString(@"LoadRequestViewController") new] animated:YES];
    }else if (indexPath.row==4){
        [self.navigationController pushViewController:[NSClassFromString(@"PostViewController") new] animated:YES];
    }
}

-(void)testCookie{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveChange) name:NSHTTPCookieManagerCookiesChangedNotification object:nil];
    
    [self addRightButton];
    //注入cookie
    [self clearHttpCookie];
    
//    [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:[NSDate dateWithTimeIntervalSince1970:-3600*24] completionHandler:^{
//
//    }];
    
//    [self storeCookieStorage:[self cookieArr]];
    
    WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
    
    /*第一种 通过UserContent 注入*/      //@"https://d.m.gome.com.cn/storeowner?storeCode=A007"
    // 视频 链接
        WKUserContentController * userContent = [[WKUserContentController alloc]init];
        NSString * cookieScript = [self userScriptCookie];
        WKUserScript * userScript = [[WKUserScript alloc]initWithSource:cookieScript injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
        [userContent addUserScript:userScript];
        webViewConfig.userContentController  =userContent;
    webViewConfig.processPool = [WKProcessPool sharedProcessPool];
    webViewConfig.allowsInlineMediaPlayback = YES;
    //webViewConfig.mediaPlaybackRequiresUserAction = NO;
    webViewConfig.allowsAirPlayForMediaPlayback = YES;
    webViewConfig.selectionGranularity = WKSelectionGranularityCharacter;
    
    
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
//        [self wkWebSiteStoreComplete:^{
//            NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"] cachePolicy:(NSURLRequestReloadIgnoringCacheData) timeoutInterval:60];
//            [self.wkWebView loadRequest:mutableRequest];
//        }];
    
    NSString * library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString * filePath = [library stringByAppendingPathComponent:@"Cookies/com.zhph.user.HandleCookies.binarycookies"] ;
    NSLog(@"HandleCookies***%@",[[NSString alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:nil]);
    [self performSelector:@selector(reloadFromOrigin) withObject:nil afterDelay:20];
}

-(void)reloadFromOrigin{
    [self.wkWebView reloadFromOrigin];
}

/*ReadAccessToURL 访问不同路径下的内容*/
-(void)loadReadAccessToURL{
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL * filePath = [NSURL fileURLWithPath:[directoryPath stringByAppendingPathComponent:@"dirA/test.html"]];
    NSURL * accessToURL = [[filePath URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] ;
    [self.wkWebView loadFileURL:filePath allowingReadAccessToURL:accessToURL];
    self.relativeURL = accessToURL;
}

/*Request 方式加载*/
-(void)loadRequest{
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://d.m.gome.com.cn"]]];
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

-(void)refreshPage{
    
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL * filePath = [NSURL fileURLWithPath:[directoryPath stringByAppendingPathComponent:@"dirB/navi.html"]];
    [self.wkWebView loadFileURL:filePath allowingReadAccessToURL:self.relativeURL];
}
#pragma mark  WKScriptMessageHandler代理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([@"testMessage" isEqualToString:message.name]) {
        NSLog(@"body***%@",message.body);
    }
}
#pragma mark 弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    completionHandler();
}
#pragma mark 确定按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    if ([message isEqualToString:@"你确定要提示出来吗"]) {
        completionHandler(true);
        return;
    }
     completionHandler(false);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
     UITextField *txtField=nil;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你好" message:@"请输入新题目:\n\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //显示之前配置txtField
    txtField = [alert textFieldAtIndex:0];
    if(txtField){
        txtField.placeholder=@"请输入用户名";
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    [alert show];
    completionHandler(@"");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    id clickButton=[alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"按下了%@按钮",clickButton);
    UITextField * txtField = [alertView textFieldAtIndex:0];
    NSLog(@"txtField%@",txtField.text);
}

#pragma mark  UIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{

//    WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
//    WKWebView * wkwebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
//    [wkwebView loadRequest:navigationAction.request];
//    return wkwebView;
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//在发起请求之前 决定跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
 
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            //超链接
            [webView loadRequest:navigationAction.request];
            break;
            
        default:
            break;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSLog(@"navigationType***%ld",navigationAction.navigationType);
    NSString * cookieScript = [self userScriptCookie];
    WKUserScript * userScript = [[WKUserScript alloc]initWithSource:cookieScript injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:userScript];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
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
//        NSString * dataStr = @"{\"token\":\"cac6af340960485aa334416c8a34ddbf\"}";        // 要访问的地址
//        NSDictionary * postData = @{
//                                    @"token":@"cac6af340960485aa334416c8a34ddbf",
//                                    @"test":@"test"
//                                    };
//
//        NSString * url = @"http://192.168.1.8:8000/show_meta/";
//        NSString * js = [NSString stringWithFormat:@"my_post(\"%@\", %@)",url,[self jsonStringEncoded:postData]];        // 最后执行JS代码
//
//        [webView evaluateJavaScript:js completionHandler:nil];        // 设置标记确保只执行一次
//        self.isOpen = NO;
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


-(void)receiveChange{
    NSLog(@"receiveChange**%@",[NSDate date]);
}

-(void)addRightButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(rightBarButtonAction)];
    
    UIButton * lastButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastButton setTitle:@"上一页" forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"上一页" style:(UIBarButtonItemStylePlain) target:self action:@selector(lastPage)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:(UIBarButtonItemStylePlain) target:self action:@selector(nextPage)];
}

-(void)lastPage{
    if (self.wkWebView.backForwardList.backItem) {
        [self.wkWebView goToBackForwardListItem:self.wkWebView.backForwardList.backItem];
    }
}

-(void)nextPage{
    if (self.wkWebView.backForwardList.forwardItem) {
        [self.wkWebView goToBackForwardListItem:self.wkWebView.backForwardList.forwardItem];
    }
}

-(void)rightBarButtonAction{
    /*apsQrhlgqqbbTXqO8mnLzP0OiT%2F1GDxZLXc%2BdlH3o9YXmRaOku1aYIaJvQ2MDMxJriF5nT5NLucLFszk4lFTJyWakRXK%2B6Cp6vZxqhIki9dPUBv5C%2F%2FO3v4NrPMTkKIN1caf0c5a5f28476ad52587f57a1356a9*/
//    [self clearHttpCookie];
//    [self clearWKWebViewCookie];
//
//    NSMutableArray * cookieList = [NSMutableArray arrayWithArray:[self cookieNewArr]];
//    [self storeCookieStorage:cookieList];
//
//    [self.wkWebView reload];
}

-(void)clearWKWebViewCookie{
    
    if (@available(iOS 9.0,*)) {
        
        WKWebsiteDataStore * webViewStore = [WKWebsiteDataStore defaultDataStore];
        [webViewStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
            [records enumerateObjectsUsingBlock:^(WKWebsiteDataRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [webViewStore removeDataOfTypes:obj.dataTypes forDataRecords:@[obj] completionHandler:^{
                    
                }];
            }];
        }];
    }else{
        
        NSString * cookiePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, NO) firstObject];
        cookiePath = [cookiePath stringByAppendingPathComponent:@"Cookies"];
        NSError * error;
        [[NSFileManager defaultManager]removeItemAtPath:cookiePath error:&error];
    }
}

-(void)clearHttpCookie{
    NSHTTPCookieStorage  * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [cookieStorage cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cookieStorage deleteCookie:obj];
    }];
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

-(NSString*)reuestCookie{
    NSMutableString * requestCookie = [NSMutableString string];
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * appendCookie = [NSString stringWithFormat:@"%@=%@;",obj.name,obj.value];
        [requestCookie appendString:appendCookie];
    }];
    
    return requestCookie;
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
    } else {
        
    }
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
//        [cookisDict setObject:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"] forKey:NSHTTPCookieOriginURL];
//        [cookisDict setObject:@TRUE forKey:NSHTTPCookieSecure];
        [cookisDict setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24*5] forKey:NSHTTPCookieExpires];
        [cookisDict removeObjectForKey:NSHTTPCookieDiscard];
//        [cookisDict setObject:@(NO) forKey:NSHTTPCookieDiscard];
//        if (obj[@"Discard"]) {
//            [cookisDict setObject:obj[@"Discard"] forKey:NSHTTPCookieDiscard];
//        }
        //单一进程 或者单一会话
//        [cookisDict setObject:@(NO) forKey:NSHTTPCookieDiscard];
//        [cookisDict setObject:@"443" forKey:NSHTTPCookiePort];
        
        [cookisDict removeObjectForKey:NSHTTPCookieDiscard];
        
//        [cookisDict setObject:@(120) forKey:NSHTTPCookieMaximumAge];
//        NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:cookisDict];
        NSHTTPCookie * httpCookie = [[NSHTTPCookie alloc]initWithProperties:cookisDict];
        [cookieStorage setCookie:httpCookie];
    }];
    
//    NSMutableDictionary * cookisDict = [NSMutableDictionary dictionary];
//    [cookisDict setObject:@"test" forKey:NSHTTPCookieName];
//    [cookisDict setObject:@"A007" forKey:NSHTTPCookieValue];
////    [cookisDict setObject:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"] forKey:NSHTTPCookieOriginURL];
//    [cookisDict setObject:@".gome.com.cn" forKey:NSHTTPCookieDomain];
//    [cookisDict setObject:@"/" forKey:NSHTTPCookiePath];
//    [cookisDict setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
//    [cookisDict setObject:@"0" forKey:NSHTTPCookieVersion];
////    [cookisDict setObject:@"3600" forKey:NSHTTPCookieMaximumAge];
//    NSHTTPCookie * httpCookie = [NSHTTPCookie cookieWithProperties:cookisDict];
//    [cookieStorage setCookie:httpCookie];
//
//
//    NSMutableDictionary * cookisDict1 = [NSMutableDictionary dictionary];
//    [cookisDict1 setObject:@"test" forKey:NSHTTPCookieName];
//    [cookisDict1 setObject:@"A008" forKey:NSHTTPCookieValue];
////    [cookisDict setObject:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"] forKey:NSHTTPCookieOriginURL];
//    [cookisDict1 setObject:@"d.m.gome.com.cn" forKey:NSHTTPCookieDomain];
//    [cookisDict1 setObject:@"/" forKey:NSHTTPCookiePath];
//    [cookisDict1 setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
//    [cookisDict1 setObject:@"0" forKey:NSHTTPCookieVersion];
//    //    [cookisDict setObject:@"3600" forKey:NSHTTPCookieMaximumAge];
//    NSHTTPCookie * httpCookie1 = [NSHTTPCookie cookieWithProperties:cookisDict1];
//    [cookieStorage setCookie:httpCookie1];
    
//   NSHTTPCookie * httpCookieTest = [[cookieStorage cookiesForURL:[NSURL URLWithString:@"https://d.m.gome.com.cn/storeowner?storeCode=A007"]]firstObject];
//
//    NSHTTPCookieStorage;
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//   NSDate * lastDate =[dateFormatter dateFromString:@"2019-04-14 09:11:30"];
//
//
//    //@"https://d.m.gome.com.cn/storeowner?storeCode=A007"
//    [cookieStorage removeCookiesSinceDate:lastDate];
    //过期设置
    [self performSelector:@selector(printCookie) withObject:nil afterDelay:30];
    
     NSLog(@"storeCookieStorage**%@",[NSDate date]);
}


-(void)printCookie{

     NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [[cookieStorage cookies]enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"properties**%@",[obj properties]);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSHTTPURLResponse * httpReponse = (NSHTTPURLResponse*)(navigationResponse.response);
    
//    NSArray *  httpCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpReponse.allHeaderFields forURL:httpReponse.URL];
//    
//   ;;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    
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

-(NSArray*)cookieNewArr{
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
                 @"Domain":@".gome.com.cn",
                 @"Version":@"1",
                 @"Created":@(576471691),
                 @"Expires":@"2019-04-13 09:32:19 +0000",
                 @"Path":@"/",
                 @"Name":@"uid",
                 @"Value":@"Cjq811yrFSibnvH0A41+Ag==",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Version":@"1",
                 @"Created":@(576471691),
                 @"Expires":@"2019-04-13 09:32:19 +0000",
                 @"Path":@"/",
                 @"Name":@"ufpd",
                 @"Value":@"7a7c7a7a537feab015dae7dd9c0b0a5231a9f7a16cd903f45477d9200f81801ae591b8b26e31632f80ca9575f8212f9101e36c42614ef19d259179984ddbedde|5cb466defTyJFL0IKW4gXiAN90LQ1aRgnOKHj8n1",
                 },
             @{
                 @"Domain":@".gome.com.cn",
                 @"Created":@(576408758),
                 @"HttpOnly":@(TRUE),
                 @"Expires":@"2019-04-15 09:32:38 +0000",
                 @"Path":@"/",
                 @"Name":@"SCN",
                 @"Value":
                     @"apsQrhlgqqbbTXqO8mnLzP0OiT%2F1GDxZLXc%2BdlH3o9YXmRaOku1aYIaJvQ2MDMxJriF5nT5NLucLFszk4lFTJyWakRXK%2B6Cp6vZxqhIki9dPUBv5C%2F%2FO3v4NrPMTkKIN1caf0c5a5f28476ad52587f57a1356a9",
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
                 @"Value":@ "apsQrhlgqqbbTXqO8mnLzP0OiT%2F1GDxZLXc%2BdlH3o9YXmRaOku1aYIaJvQ2MDMxJriF5nT5NLucLFszk4lFTJyWakRXK%2B6Cp6vZxqhIki9dPUBv5C%2F%2FO3v4NrPMTkKIN1caf0c5a5f28476ad52587f57a1356a9",
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
