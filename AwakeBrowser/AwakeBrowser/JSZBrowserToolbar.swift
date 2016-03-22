//
//  JSZBrowserToolbar.swift
//  AwakeBrowser
//
//  Created by Jordan Zucker on 3/20/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit

enum JSZBrowserNavigationItem: String {
    case Reload
    case Back
    case Forward
    case Cancel
}

enum JSZBrowserNavigationState: String {
    case NotLoading
    case Loading
}

class JSZBrowserToolbar: UIView, UITextFieldDelegate {
    
    var inputField: UITextField!
    var backButton: UIButton!
    var forwardButton: UIButton!
    var awakeSwitch: UISwitch!
    var rightButton: UIButton!
    var navigationState = JSZBrowserNavigationState.NotLoading
    var shareButton: UIButton!

    weak var delegate: JSZBrowserToolbarDelegate?
    
    override init(frame: CGRect) {
        self.inputField = UITextField(frame: CGRectZero)
        self.inputField.borderStyle = .Line
        self.inputField.clearButtonMode = .WhileEditing
        self.inputField.autocapitalizationType = .None
        self.inputField.autocorrectionType = .No
        self.inputField.spellCheckingType = .No
        self.forwardButton = UIButton(type: .System)
        self.backButton = UIButton(type: .System)
        self.forwardButton.setTitle("F", forState: .Normal)
        self.backButton.setTitle("B", forState: .Normal)
        self.awakeSwitch = UISwitch()
        self.rightButton = UIButton(type: .System)
        self.shareButton = UIButton(type: .System)
        self.shareButton.setTitle("S", forState: .Normal)
        super.init(frame: frame)
        self.addSubview(inputField)
        self.addSubview(forwardButton)
        self.addSubview(backButton)
        self.addSubview(awakeSwitch)
        self.addSubview(shareButton)
        inputField.rightViewMode = .UnlessEditing
        inputField.rightView = rightButton
        
        inputField.delegate = self
//        self.backgroundColor = UIColor.greenColor()
        self.backgroundColor = UIColor.purpleColor();
        awakeSwitch.addTarget(self, action: #selector(JSZBrowserToolbar.awakeSwitchValueChanged(_:)), forControlEvents: .ValueChanged)
        backButton.addTarget(self, action: #selector(JSZBrowserToolbar.didTapBackButton(_:)), forControlEvents: .TouchUpInside)
        forwardButton.addTarget(self, action: #selector(JSZBrowserToolbar.didTapForwardButton(_:)), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(JSZBrowserToolbar.didTapRightButton(_:)), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(JSZBrowserToolbar.didTapShareButton(_:)), forControlEvents: .TouchUpInside)
        applyLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyLayoutConstraints() {
        inputField.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        awakeSwitch.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        let views = ["inputField": inputField, "forwardButton": forwardButton, "backButton": backButton, "awakeSwitch": awakeSwitch, "shareButton": shareButton]
        let metrics = ["inputFieldTopPadding": 5.0, "inputFieldBottomPadding": 5.0, "inputFieldLeftPadding": 5.0, "inputFieldRightPadding": 5.0, "navigationButtonsWidth": 10.0, "navigationButtonsHeight": 20.0, "navigationButtonsTopPadding": 10.0]
        let inputFieldHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[backButton(navigationButtonsWidth)]-2-[forwardButton(navigationButtonsWidth)]-inputFieldLeftPadding-[inputField]-inputFieldRightPadding-[shareButton(10)]-5-[awakeSwitch]-5-|", options: [], metrics: metrics, views: views)
        let inputFieldVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-inputFieldTopPadding-[inputField]-inputFieldBottomPadding-|", options: [], metrics: metrics, views: views)
        let forwardButtonVerticalConstraint = NSLayoutConstraint(item: forwardButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.5, constant: 0.0)
        let backButtonVerticalConstraint = NSLayoutConstraint(item: backButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.5, constant: 0.0)
        let forwardButtonVerticalCenterConstraints = NSLayoutConstraint(item: forwardButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let backButtonVerticalCenterConstraints = NSLayoutConstraint(item: backButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let awakeSwitchVerticalCenterConstraint = NSLayoutConstraint(item: awakeSwitch, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let shareButtonVerticalCenterConstraint = NSLayoutConstraint(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let shareButtonVerticalConstraint = NSLayoutConstraint(item: shareButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.5, constant: 0.0)
        self.addConstraints(inputFieldHorizontalConstraints)
        self.addConstraints(inputFieldVerticalConstraints)
        self.addConstraints([forwardButtonVerticalConstraint, backButtonVerticalConstraint])
        self.addConstraints([forwardButtonVerticalCenterConstraints, backButtonVerticalCenterConstraints])
        self.addConstraint(awakeSwitchVerticalCenterConstraint)
        self.addConstraints([shareButtonVerticalConstraint, shareButtonVerticalCenterConstraint])
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.toolbarDidReturnWithText(textField.text)
        return true
    }
    
    var forwardButtonEnabled: Bool {
        get {
            return forwardButton.enabled
        }
        
        set {
            forwardButton.enabled = newValue
        }
    }
    
    var backButtonEnabled: Bool {
        get {
            return backButton.enabled
        }
        
        set {
            backButton.enabled = newValue
        }
    }
    
    func setLoading(loading: Bool) {
        let rightButtonTitle: String
        if (loading) {
            navigationState = .Loading
            rightButtonTitle = "C"
        } else {
            navigationState = .NotLoading
            rightButtonTitle = "R"
        }
        rightButton.setTitle(rightButtonTitle, forState: .Normal)
        rightButton.sizeToFit()
    }
    
    var awakeSwitchOn: Bool {
        get {
            return awakeSwitch.on
        }
        
        set {
            awakeSwitch.setOn(newValue, animated: false)
            delegate?.toolbarAwakeSwitchValueChanged(newValue)
        }
    }
    
    func awakeSwitchValueChanged(sender: UISwitch) {
        delegate?.toolbarAwakeSwitchValueChanged(sender.on)
    }
    
    func didTapForwardButton(sender: UIButton) {
        delegate?.toolbarDidReceiveNavigationAction(.Forward)
    }
    
    func didTapBackButton(sender: UIButton) {
        delegate?.toolbarDidReceiveNavigationAction(.Back)
    }
    
    func didTapShareButton(sender: UIButton) {
        delegate?.toolbarDidTapShareButton(inputField.text)
    }
    
    func updateTextFieldWithURL(URL: NSURL?) {
        if let aURL = URL {
            inputField.text = aURL.absoluteString
        } else {
            inputField.text = ""
        }
    }
    
    func didTapRightButton(sender: UIButton) {
        switch navigationState {
        case .NotLoading:
            delegate?.toolbarDidReceiveNavigationAction(.Reload)
        case .Loading:
            delegate?.toolbarDidReceiveNavigationAction(.Cancel)
        }
    }
}

protocol JSZBrowserToolbarDelegate: class {
    func toolbarDidReturnWithText(text: String?)
    func toolbarDidReceiveNavigationAction(action: JSZBrowserNavigationItem)
    func toolbarAwakeSwitchValueChanged(awakeSwitchValue: Bool)
    func toolbarDidTapShareButton(urlString: String?)
}
