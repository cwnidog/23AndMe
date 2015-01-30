//
//  MaternalLineViewController.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 1/29/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class MaternalLineViewController: UIViewController, UIWebViewDelegate
{
  
  
  @IBOutlet weak var webView: UIWebView!
  
  var maternalWebURL : String?
  

  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool)
  {
    if (NetworkController.sharedNetworkController.maternalHaplogroup == nil)
    { // fetch info
      NetworkController.sharedNetworkController.fetchUserHaplogroup( { (maternalHaplo, paternalHaplo, errorString) -> (Void) in
        if(errorString == nil)
        {
          if(maternalHaplo != nil)
          {
            self.maternalWebURL = "https://www.23andme.com/you/haplogroup/maternal/?viewgroup=\(maternalHaplo!)&tab=story"
            NetworkController.sharedNetworkController.maternalHaplogroup = maternalHaplo
          }
          NetworkController.sharedNetworkController.paternalHaplogroup = maternalHaplo
        }
        if(self.maternalWebURL != nil)
        {
          let request = NSURLRequest(URL: NSURL(string: self.maternalWebURL!)!)
          self.webView.loadRequest(request)
          self.webView.reload()
        }
      })
    } else { // this will fire when the webView has been loaded previously.
      let maternal = NetworkController.sharedNetworkController.maternalHaplogroup
      self.maternalWebURL = "https://www.23andme.com/you/haplogroup/maternal/?viewgroup=\(maternal!)&tab=story"
      let request = NSURLRequest(URL: NSURL(string: self.maternalWebURL!)!)
      self.webView.loadRequest(request)
      self.webView.reload()
    }
  }
  

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

}
