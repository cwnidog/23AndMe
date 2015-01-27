//
//  MaternalWebViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/26/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit
import WebKit

class MaternalWebViewController: UIViewController {
  
  let webView = WKWebView()
  var maternalUrl : String!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.webView.frame = self.view.frame  // define's the webView's size
      self.view.addSubview(self.webView) // add it to the subView
      
      //let request = NSURLRequest(URL: NSURL(string: self.maternalUrl)!)  // sends the request to the website. Where does the URL come from????
      //self.webView.loadRequest(request)  // loads the website into the WebView
      
      // self.navigationController?.delegate = nil // <- I don't think we need this

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
