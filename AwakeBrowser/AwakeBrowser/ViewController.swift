//
//  ViewController.swift
//  AwakeBrowser
//
//  Created by Jordan Zucker on 3/19/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    var webView: WKWebView
//    @IBOutlet weak var barView: UIView!
//    @IBOutlet weak var barView: UINavigationBar!
    var navigationBar: UINavigationBar!
    var urlField: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        self.navigationBar = UINavigationBar(frame: CGRectZero)
        self.urlField = UITextField(frame: CGRectZero)
        super.init(coder: aDecoder)
        
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlField.delegate = self
        urlField.borderStyle = .Line
//        barView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        view.insertSubview(navigationBar, aboveSubview: webView)
        view.insertSubview(webView, belowSubview: progressView)
        navigationBar.addSubview(urlField)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        urlField.translatesAutoresizingMaskIntoConstraints = false
        let views = ["navigationBar": navigationBar!, "urlField": urlField, "progressView": progressView]
        let metrics = ["navigationBarHeight": 60.0, "urlFieldTopYPadding": 25.0, "urlFieldBottomYPadding": 5.0, "urlFieldXPadding": 15.0]
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        let barWidth = NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy:.Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        let barHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[navigationBar(navigationBarHeight)]", options: [], metrics: metrics, views: views)
        view.addConstraints([height, width, barWidth])
        view.addConstraints(barHeightConstraints)
        
        let urlFieldYConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-urlFieldTopYPadding-[urlField]-urlFieldBottomYPadding-|", options: [], metrics: metrics, views: views)
        let urlFieldXConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-urlFieldXPadding-[urlField]-urlFieldXPadding-|", options: [], metrics: metrics, views: views)
        navigationBar.addConstraints(urlFieldXConstraints)
        navigationBar.addConstraints(urlFieldYConstraints)
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        let url = NSURL(string:"http://www.google.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        backButton.enabled = false
        forwardButton.enabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        webView.loadRequest(NSURLRequest(URL:NSURL(string: urlField.text!)!))
        
        return false
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL:webView.URL!)
        webView.loadRequest(request)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
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
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }


}

