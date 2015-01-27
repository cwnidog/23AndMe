//
//  MaternalWebViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/26/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit
import WebKit

class MaternalWebViewController: UIViewController, UIWebViewDelegate
{
  
  @IBOutlet weak var webView  : UIWebView!
  
  var maternalWebURL : String?

  
  override func viewDidLoad()
  {
    super.viewDidLoad()
      
      
    if(self.maternalWebURL != nil)
    {
      let request = NSURLRequest(URL: NSURL(string: self.maternalWebURL!)!)
      self.webView.loadRequest(request)
    } else {  // go to google
      let url     = NSURL(string: "http://www.google.com")
      let request = NSURLRequest(URL: url!)
      self.webView.loadRequest(request)
    }
  }

      
      //self.webView.frame = self.view.frame  // define's the webView's size
      //self.view.addSubview(self.webView) // add it to the subView
      
      //let request = NSURLRequest(URL: NSURL(string: self.maternalUrl)!)  // sends the request to the website. Where does the URL come from????
      //self.webView.loadRequest(request)  // loads the website into the WebView
      
      // self.navigationController?.delegate = nil // <- I don't think we need this

        // Do any additional setup after loading the view.

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
