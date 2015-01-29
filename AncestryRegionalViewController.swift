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
    
    self.tableView.registerNib(UINib(nibName: "RegionalCell",
                                      bundle: NSBundle.mainBundle()),
                      forCellReuseIdentifier: "REGIONAL_CELL")
    
    // populates the array of SubRegion objects -> these are inside of the region object
   /*if let subRegion = self.region.subRegions
   {
      self.subRegions = subRegion
   }*/
    
    if let subRegion = self.region.subRegions
    {
      for item in subRegion
      {
        let sub = SubRegion(jsonDictionary: item)
        subRegions.append(sub)
      }
    }
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return subRegions.count
  }

  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("REGIONAL_CELL", forIndexPath: indexPath) as RegionalCell
    
    let currentSubRegion = self.subRegions[indexPath.row]
    
    println("\(self.subRegions[indexPath.row].region)")
    
    cell.regionalNameLabel.text = currentSubRegion.region
    //this method will convert the proportion(a Float) to a string
    cell.regionalPercentageLabel.text = self.region.convertFloatToString(currentSubRegion.proportion) + "%"

    
    
    
    return cell
  }
  
  
  // function to let you tap the cell and go to the country page
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    println("\(indexPath.row) selected")
    
    let subRegionToCountry = self.subRegions[indexPath.row]
    
    let toCountryVC = storyboard?.instantiateViewControllerWithIdentifier("COUNTRY_VC") as Country2ViewController
    
    toCountryVC.subRegion = subRegionToCountry
    
    self.navigationController?.pushViewController(toCountryVC, animated: true)
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
