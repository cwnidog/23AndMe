//
//  PaternalLineViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class PaternalLineViewController: UIViewController, UIWebViewDelegate
{

  @IBOutlet weak var webView  : UIWebView!
  
  var paternalWebURL : String?
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.webView.delegate = self
     
    if(self.paternalWebURL != nil)
    {
      let request = NSURLRequest(URL: NSURL(string: paternalWebURL!)!)
      self.webView.loadRequest(request)
    } else {  // go to reddit!
      let url     = NSURL(string: "http://www.reddit.com")
      let request = NSURLRequest(URL: url!)
      self.webView.loadRequest(request)
    }
  }

  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
