//
//  ViewController.m
//  AwakeBrowser
//
//  Created by Jordan Zucker on 3/19/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ViewController.h"

@interface ViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
