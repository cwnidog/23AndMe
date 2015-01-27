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
  
  @IBOutlet weak var tableView: UITableView!
  
  var global = [GlobalCatagory]()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // initiate variables
    self.tableView.dataSource = self
      // Do any additional setup after loading the view.
  }
  
  
  // UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // fulfills tableView requirement to tell how many rows to make
    return self.global.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GLOBAL_CELL", forIndexPath: indexPath) as GlobalCell
    // return cell
    
    let global2 = self.global[indexPath.row]  // defines the single repo
    //    println("\(repository)")
    //
    // Puts on the labels
    cell.globalNameLabel.text = global2.globalName
    cell.globalPercentageLabel.text = global2.globalNamePercentage
  
    
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
