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
    self.accentImage.image = UIImage(named: "gel0.jpg")
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
