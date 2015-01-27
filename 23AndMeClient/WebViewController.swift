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
      
      let url = "https://api.23andme.com/authorize/?redirect_uri=http://localhost:5000/receive_code/&response_type=code&client_id=\(NetworkController.sharedNetworkController.clientID)&scope=basic%20haplogroups%20ancestry%20names"
      self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
      // Do any additional setup after loading the view.
    }
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    println(navigationAction.request.URL)
    
    if navigationAction.request.URL.description.rangeOfString("code=") != nil {
      NetworkController.sharedNetworkController.handleCallbackURL(navigationAction.request.URL)
      
    }
    decisionHandler(WKNavigationActionPolicy.Allow)
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
