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
    for subRegion in self.region.subRegions!
    {
      self.subRegions.append(subRegion)
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
    
    cell.regionalNameLabel.text = currentSubRegion.region
    //this method will convert the proportion(a Float) to a string
    cell.regionalPercentageLabel.text = self.region.convertFloatToString(currentSubRegion.proportion)
    
    return cell
  }

  
    override func didReceiveMemoryWarning()
    {
      super.didReceiveMemoryWarning()
    }
}
