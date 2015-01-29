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
  
  //this is just the default value for testing
  let profileID = "SP1_FATHER_V4"

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
    self.netController.fetchAncestryComposition(self.profileID, callback: { (region, errorString) -> (Void) in
      if(errorString == nil)
      {
        self.global = region!
        self.tableView.reloadData()
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
    
    //quick & sloppy randomization of the images
    if(indexPath.row % 2 == 0)
    {
       cell.countryImage.image = UIImage(named: "oceania0.jpeg")
    } else if(indexPath.row % 3 == 0)
    {
       cell.countryImage.image = UIImage(named: "europe0.jpeg")
    } else {
       cell.countryImage.image = UIImage(named: "southAsia0.jpeg")
    }
  
    //little bit o'razzle dazzle
    cell.alpha     = 0.0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.5) // alertView.transforms initial value
    
    UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: { () -> Void in
      cell.alpha     = 0.75
      cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        cell.alpha   = 1.0
    }
    
    return cell
  }
  
  // function to let you tap the cell and go to the subRegion page
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("Did select item") }
    
    // custom segue to go to the next page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SHOW_SUBREGIONAL" {
        let destinationVC = segue.destinationViewController as AncestryRegionalViewController
        // let selectedIndexPath = self.tableView[indexPath.row] as NSIndexPath  // <- not sure what the first does
        let selectedIndexPath = self.tableView.indexPathForSelectedRow()! as NSIndexPath
        destinationVC.region = self.global[selectedIndexPath.row]
      }
    }


//    // Instantiates the view controller with the specified identifier (the detailed page)
//    let globalVC = self.storyboard?.instantiateViewControllerWithIdentifier("GLOBAL_VC") as AncestryGlobalViewController
//    globalVC.networkController = self.networkController
//    globalVC.currentRegion = self.global[indexPath.row]
//    
//    // Pushes a view controller onto the receiver’s stack and updates the display
//    self.navigationController?.pushViewController(globalVC, animated: true)
//  }
  

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
}
