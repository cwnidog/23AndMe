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
  
  override func loadView() {
    super.loadView()
    self.webView.delegate = self
    if (NetworkController.sharedNetworkController.paternalHaplogroup == nil)
    { // fetch info
      NetworkController.sharedNetworkController.fetchUserHaplogroup( { (maternalHaplo, paternalHaplo, errorString) -> (Void) in
        if(errorString == nil)
        {
          println("paternalHaplo = \(paternalHaplo)")
          if(paternalHaplo != nil)
          {
            self.paternalWebURL = "https://www.23andme.com/you/haplogroup/paternal/?viewgroup=\(paternalHaplo!)&tab=story"
            NetworkController.sharedNetworkController.paternalHaplogroup = paternalHaplo
            let request = NSURLRequest(URL: NSURL(string: self.paternalWebURL!)!)
            self.webView.loadRequest(request)
          } else {
            println("no paternal haplogroup listed, profile is of a female")
          }
          NetworkController.sharedNetworkController.maternalHaplogroup = maternalHaplo
        } 
      })
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    println(self.paternalWebURL)
    
    self.webView.reload()
    //self.webView.delegate = self
     /*
    if(self.paternalWebURL != nil)
    {
      let request = NSURLRequest(URL: NSURL(string: paternalWebURL!)!)
      self.webView.loadRequest(request)
    } else {  // go to reddit!
      let url     = NSURL(string: "http://www.reddit.com")
      let request = NSURLRequest(URL: url!)
      self.webView.loadRequest(request)
    }*/
  }

  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
