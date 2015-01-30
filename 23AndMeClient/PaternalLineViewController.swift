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

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var webView  : UIWebView!
  
  var paternalWebURL : String?

  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.activityIndicator.hidden = false
  }

  override func viewDidAppear(animated: Bool)
  {
    if (NetworkController.sharedNetworkController.paternalHaplogroup == nil)
    { // fetch info
      NetworkController.sharedNetworkController.fetchUserHaplogroup( { (maternalHaplo, paternalHaplo, errorString) -> (Void) in
        if(errorString == nil)
        {
          if(paternalHaplo != nil)
          {
            self.paternalWebURL = "https://www.23andme.com/you/haplogroup/paternal/?viewgroup=\(paternalHaplo!)&tab=story"
            NetworkController.sharedNetworkController.paternalHaplogroup = paternalHaplo
          } else {
            println("no paternal haplogroup listed, profile is of a female")
          }
          NetworkController.sharedNetworkController.maternalHaplogroup = maternalHaplo
        }
        if (self.paternalWebURL != nil)
        {
          let request = NSURLRequest(URL: NSURL(string: self.paternalWebURL!)!)
          self.activityIndicator.hidden = true
          self.webView.loadRequest(request)
        }
      })
    } else { // this will fire when the webView has been loaded previously.
      let paternal = NetworkController.sharedNetworkController.paternalHaplogroup
      self.paternalWebURL = "https://www.23andme.com/you/haplogroup/paternal/?viewgroup=\(paternal!)&tab=story"
      let request = NSURLRequest(URL: NSURL(string: self.paternalWebURL!)!)
      self.activityIndicator.hidden = true
      self.webView.loadRequest(request)
    }
  }

  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
