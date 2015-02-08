//
//  WebViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
  
  let webView = WKWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.webView.frame = self.view.frame
    self.view.addSubview(self.webView)
    self.webView.navigationDelegate = self
    
    // set upconstraint so that the webView is always in the center of it's container
    // lifted code from Stack Overflow
    self.webView.setTranslatesAutoresizingMaskIntoConstraints(true) // this time, we want it
    
    // make all four webView margins flexible, so they'll adjust to the container
    self.webView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin
    
    // center the webView in the container
    self.webView.center = CGPointMake(self.view.bounds.midX, self.view.bounds.midY)
    
    let url = "https://api.23andme.com/authorize/?redirect_uri=http://localhost:5000/receive_code/&response_type=code&client_id=\(NetworkController.sharedNetworkController.clientID)&scope=basic%20haplogroups%20ancestry%20names"
    self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
  } // viewDidLoad()
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    //println(navigationAction.request.URL)
    
    // if we get a code back from 23andMe, dismiss the webView and pass the URL on back to the NetworkController to use to get an initial or refreshed token
    if navigationAction.request.URL.description.rangeOfString("code=") != nil {
      
      // request the token from 23andMe and then ask teh NetworkController to request the user's profiles, which we need for any further requests
      NetworkController.sharedNetworkController.handleCallbackURL(navigationAction.request.URL, completionHandler: { () -> () in
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
         NetworkController.sharedNetworkController.fetchProfileID((), callback: { (profiles, userID, errorDescription) -> (Void) in
              NetworkController.sharedNetworkController.profiles = profiles!
              NetworkController.sharedNetworkController.userID = userID!
            }) // fetchProfileID enclosure
        }) // dismissViewControllerAnimated enclosure
      }) // handleCallbackURL enclosure
    } // if navigationAction
    
    decisionHandler(WKNavigationActionPolicy.Allow) // OK to move away from the web view
    
  } // webView()
  
} // WebViewController()
