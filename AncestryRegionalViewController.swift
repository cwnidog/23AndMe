//
//  AncestryRegionalViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class AncestryRegionalViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var regional = [RegionalCatagory]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // initiate variables
      self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
  
  // UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // fulfills tableView requirement to tell how many rows to make
    return self.regional.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REGIONAL_CELL", forIndexPath: indexPath) as RegionalCell
    // return cell
    

    
    let regional2 = self.regional[indexPath.row]
    
    //    println("\(regional2)")
    //
    // Puts on the labels
    
    cell.regionalNameLabel.text = regional2.regionalName
    cell.regionalPercentageLabel.text = regional2.regionalNamePercentage
    
    return cell
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
