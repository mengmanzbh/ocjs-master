//
//  ViewController.m
//  ocjs
//
//  Created by 谢霆锋 on 15/12/15.
//  Copyright © 2015年 lll. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *reload;
@end

@implementation ViewController
- (UIButton *)reload{

    if (!_reload) {
        _reload = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-50, CGRectGetWidth(self.view.bounds), 50)];
        _reload.backgroundColor = [UIColor brownColor];
        [_reload setTitle:@"刷新" forState:UIControlStateNormal];
        [_reload setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_reload addTarget:self action:@selector(reloadweb:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _reload;
}
- (void)reloadweb:(UIButton *)btn{
    NSLog(@"网页刷新");
    [self.webView reload];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self loadExamplePage:self.webView];
    [WebViewJavascriptBridge enableLogging];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js传过来的数据:%@", data);
        responseCallback(@"oc data");
    }];
    
    //发送数据给js
//    [self.bridge send:@"111"];
//    [self.bridge send:[NSDictionary dictionaryWithObject:@"Foo" forKey:@"Bar"]];
//    [self.bridge send:@"你是否确定？" responseCallback:^(id responseData) {
//        NSLog(@"用户点击了按钮 %@", responseData);
//    }];
    //注册一个方法给js调用
    [self.bridge registerHandler:@"camera" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用摄像机");
        responseCallback([NSNumber numberWithInt:[UIScreen mainScreen].bounds.size.height]);
    }];
    //调用js中的方法showAlert
//    [self.bridge callHandler:@"showAlert" data:@"11"];
    
   
    [self.view addSubview:self.reload];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}
- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"licai" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}


@end
