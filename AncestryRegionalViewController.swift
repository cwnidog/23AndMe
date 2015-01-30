//
//  AncestryRegionalViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class AncestryRegionalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  //after a region is selected in the previous VC -> its subRegions are loaded in this tableView
   var region : Regions!
  
   var subRegions = [SubRegion]()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // initiate variables
    self.tableView.dataSource = self
    self.tableView.delegate   = self
    
    self.tableView.registerNib(UINib(nibName: "GlobalCell",
                                      bundle: NSBundle.mainBundle()),
                      forCellReuseIdentifier: "GLOBAL_CELL")
    
    if let subRegion = self.region.subRegions
    {
      for item in subRegion
      {
        let sub = SubRegion(jsonDictionary: item)
        subRegions.append(sub)
      }
      self.tableView.reloadData()
    }
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return subRegions.count
  }

  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("GLOBAL_CELL", forIndexPath: indexPath) as GlobalCell
    
    let currentSubRegion = self.subRegions[indexPath.row]
    cell.globalLabel.text = currentSubRegion.region
        //this method will convert the proportion(a Float) to a string
    cell.globalProportion.text = self.region.convertFloatToString(currentSubRegion.proportion) + "%"

    cell.countryImage.image = UIImage(named: "sub\(indexPath.row)")
    
    cell.alpha     = 0.0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.5) // alertView.transforms initial value
    
    UIView.animateWithDuration(0.3, delay: 0.1, options: nil, animations: { () -> Void in
      cell.alpha     = 0.75
      cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        cell.alpha   = 1.0
    }
    
    
    return cell
  }
  
  
  // function to let you tap the cell and go to the country page
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    let subRegionToCountry = self.subRegions[indexPath.row]
    
    if (subRegionToCountry.countries == nil) // this will skip to the celebrities VC if the countires array is empty.
    {
      let toCountryVC = storyboard?.instantiateViewControllerWithIdentifier("CELEBRITY_VC") as CelebrityInterestViewController
      
      toCountryVC.subRegion = subRegionToCountry
      
      self.navigationController?.pushViewController(toCountryVC, animated: true)
    } else {
      
      let toCountryVC = storyboard?.instantiateViewControllerWithIdentifier("COUNTRY_VC") as Country2ViewController
      
      toCountryVC.subRegion = subRegionToCountry
      
      self.navigationController?.pushViewController(toCountryVC, animated: true)
    }
  }
  
  
  
  
  
  
  
  
  
  /* custom segue to go to the next page
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_COUNTRY" {
      let destinationVC = segue.destinationViewController as Country2ViewController
      //let selectedIndexPath = self.tableView[indexPath.row] as NSIndexPath  // <- not sure what the first does
      let selectedIndexPath = self.tableView.indexPathForSelectedRow()! as NSIndexPath
      destinationVC.subRegion = self.subRegions[selectedIndexPath.row]
    }
  }*/

  
    override func didReceiveMemoryWarning()
    {
      super.didReceiveMemoryWarning()
    }
}
