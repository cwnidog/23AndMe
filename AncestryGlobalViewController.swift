//
//  AncestryGlobalViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/26/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class AncestryGlobalViewController: UIViewController, UITableViewDataSource
{
  var netController : NetworkController!
  
  @IBOutlet weak var tableView: UITableView!
  
  var global = [Regions]()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
    
    // initiate variables
    self.tableView.dataSource = self
    self.tableView.registerNib(UINib(nibName: "GlobalCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "GLOBAL_CELL")
    
    
    //TODO: need to pass userID here, or store it in netController
    self.netController.fetchAncestryComposition(nil, callback: { (region, errorString) -> (Void) in
      if(errorString == nil)
      {
        self.global = region!
      }
    })
  }
  
  
  // UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // fulfills tableView requirement to tell how many rows to make
    return self.global.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("GLOBAL_CELL", forIndexPath: indexPath) as GlobalCell 
    
    let currentRegion = self.global[indexPath.row]
    
    cell.globalLabel.text = currentRegion.region
    //this method will convert the proportion(a Float) to a string
    cell.globalProportion.text = currentRegion.convertFloatToString(currentRegion.proportion)
    
    cell.countryImage.image = UIImage(named: "oceania0.jpeg")

    return cell
  }
  

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
