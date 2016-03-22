//
//  JSZBrowserViewController.swift
//  AwakeBrowser
//
//  Created by Jordan Zucker on 3/20/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import WebKit

extension String {
    func request() -> NSURLRequest? {
        let URL = NSURL(string: self)
        return NSURLRequest(URL: URL!)
    }
}

class JSZBrowserViewController: UIViewController, WKNavigationDelegate, JSZBrowserToolbarDelegate {
    
    let initialWebsiteURLString = "https://www.google.com"
    
    var webView: JSZWebView!
    var toolbar: JSZBrowserToolbar!
    var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = JSZWebView(frame: CGRectZero)
        self.toolbar = JSZBrowserToolbar(frame: CGRectZero)
        self.progressView = UIProgressView(progressViewStyle: .Default)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(webView)
        view.addSubview(toolbar)
        toolbar.delegate = self
        view.addSubview(progressView)
        webView.navigationDelegate = self
        applyLayoutConstraints()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.loadRequest(initialWebsiteURLString.request()!)
        toolbar.awakeSwitchOn = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyLayoutConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["webView": webView, "toolbar": toolbar, "progressView": progressView]
        let metrics = ["toolbarHeight": 50.0, "statusBarHeight": 20.0]
        let webViewHorizontalConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let toolbarHorizontalConstraint = NSLayoutConstraint(item: toolbar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-statusBarHeight-[toolbar(toolbarHeight)][progressView][webView]|", options: [], metrics: metrics, views: views)
        view.addConstraint(webViewHorizontalConstraint)
        view.addConstraint(toolbarHorizontalConstraint)
        view.addConstraints(verticalConstraints)
        
    }
    
    func toolbarDidReturnWithText(text: String?) {
        webView.loadRequest((text?.request())!)
    }
    
    func toolbarAwakeSwitchValueChanged(awakeSwitchValue: Bool) {
        UIApplication.sharedApplication().idleTimerDisabled = awakeSwitchValue
    }
    
    func toolbarDidTapShareButton(sourceView: UIView!) {
        if let currentURL = webView.URL {
            presentViewController(JSZActivityViewController.activityViewController(currentURL, sourceView: sourceView), animated: true, completion: nil)
        }
    }
    
    func toolbarDidReceiveNavigationAction(action: JSZBrowserNavigationItem) {
        switch action {
        case .Back:
            webView.goBack()
        case .Forward:
            webView.goForward()
        case .Reload:
            webView.reload()
        case .Cancel:
            webView.stopLoading()
        case .BackHistory:
            print(action.rawValue)
//            if let backItem = webView.backForwardList.backItem {
//                webView.goToBackForwardListItem(backItem)
//            }
        case .ForwardHistory:
            print(action.rawValue)
//            if let forwardItem = webView.backForwardList.forwardItem {
//                webView.goToBackForwardListItem(forwardItem)
//            }
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            toolbar.backButtonEnabled = webView.canGoBack
            toolbar.forwardButtonEnabled = webView.canGoForward
            if let newValue = change?[NSKeyValueChangeNewKey] as? NSNumber {
                toolbar.setLoading(newValue.boolValue)
            }
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        toolbar.updateTextFieldWithURL(webView.URL)
    }

}
