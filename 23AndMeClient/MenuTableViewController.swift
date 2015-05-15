//
//  MenuTableViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
  
  @IBOutlet weak var accentImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // ask user if they have a genetic profile through a separate View Controller
    let gpVC = self.storyboard?.instantiateViewControllerWithIdentifier("GeneticContentVC") as! GeneticProfileViewController
    self.navigationController?.pushViewController(gpVC, animated: true)
    
    if (NetworkController.sharedNetworkController.accessToken == nil)
    {
      let toVC = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserVC") as! PageViewController
      self.navigationController?.pushViewController(toVC, animated: true)
    }
    
  } // viewDidLoad()
  
  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    self.navigationController?.delegate = nil // make sure that here are no zombies
    
    // if we don't have a stored access token we need to ask for one
    if (NetworkController.sharedNetworkController.accessToken == nil || NetworkController.sharedNetworkController.needRefresh)
    {
      if NetworkController.sharedNetworkController.accessToken == nil
      {
        println("Access token is nil, setting up the web controller to ask for an initial token")
      } // access token == nil
      
      else
      {
        println("Access token has timed out, setting up the web controller to ask for a new token")
      }
      let webVC = WebViewController()
      self.presentViewController(webVC, animated: true, completion: { () -> Void in
      }) // enclosure
    } // if accessToken == nil
    else
    {
    // we need to get the profile IDs
      NetworkController.sharedNetworkController.fetchProfileID((), callback: { (profiles, userID, errorDescription) -> (Void) in
        NetworkController.sharedNetworkController.profiles = profiles!
        NetworkController.sharedNetworkController.userID = userID!
      }) // fetchProfileID enclosure
    }
  } //viewDidAppear()
 } // MenuTableViewController
