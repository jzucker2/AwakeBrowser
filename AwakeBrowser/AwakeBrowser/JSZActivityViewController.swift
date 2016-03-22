//
//  JSZActivityViewController.swift
//  AwakeBrowser
//
//  Created by Jordan Zucker on 3/21/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit

class JSZActivityViewController: NSObject {
    class func activityViewController(URL: NSURL!, sourceView: UIView!) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: [URL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        return activityViewController
    }

}
