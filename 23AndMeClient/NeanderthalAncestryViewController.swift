//
//  NeanderthalAncestryViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit
import Social

class NeanderthalAncestryViewController: UIViewController {

  @IBOutlet weak var NeanderthalImage: UIImageView!
  @IBOutlet weak var percentageNeanderthalLabel: UILabel!
  
  let neanderthalImage = UIImage(named: "neanderthalImage") // use a stored image to save time
  
    override func viewDidLoad()
    {
      super.viewDidLoad()
      NetworkController.sharedNetworkController.fetchNeanderthal((), callback: { (neanderDict, error) -> (Void) in
        //initialize a Neanderthal with the provided JSON data
        var neanderthal = Neanderthal(jsonDictionary: neanderDict)
        
        // display the data
        self.NeanderthalImage.image = self.neanderthalImage
        self.percentageNeanderthalLabel.text = neanderthal.proportion
        self.NeanderthalImage.layer.cornerRadius = 10.0
        self.NeanderthalImage.clipsToBounds = true

      }) // callback enclosure
    } // viewDidLoad()
  
  func screenShotMethod() -> UIImage {
    //Create the UIImage
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.renderInContext(UIGraphicsGetCurrentContext())
    let screenshotImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    //Save it to the camera roll
    UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil)
    return screenshotImage
  } // <- close func screenShot Method
  
  @IBAction func twitterButtonPressed(sender: UIButton) {
    let myImage = screenShotMethod()
    if SLComposeViewController.isAvailableForServiceType (SLServiceTypeTwitter) {
      var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      twitterSheet.setInitialText("Check-out who has common ancestory as me! ~CelebriMe23")
      twitterSheet.addImage(myImage)
      self.presentViewController(twitterSheet, animated: true, completion: nil)
    } else {
      var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion:nil)
    }
  } // <-close twitterbuttonpressed
  
  @IBAction func facebookButtonPressed(sender: UIButton) {
    let myImage = screenShotMethod()
    if SLComposeViewController.isAvailableForServiceType (SLServiceTypeFacebook) {
      var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
      facebookSheet.setInitialText("Check-out who has common ancestory as me! ~CelebriMe23")
      facebookSheet.addImage(myImage)
      self.presentViewController(facebookSheet, animated: true, completion: nil)
    } else {
      var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion:nil)
    }
  } // <- close facebookbuttonpressed

} // NeanderthalAncestryViewController()
