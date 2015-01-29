//
//  Country2ViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/28/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class Country2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var subRegion : SubRegion!
  
  var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.tableView.dataSource = self
      self.tableView.delegate   = self
      
      self.tableView.registerNib(UINib(nibName: "RegionalCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "COUNTRY_CELL")
      
      for country in self.subRegion.countries! {
        self.countries.append(country)
      }
  }
  
      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("COUNTRY_CELL", forIndexPath: indexPath) as RegionalCell
        
        let currentCountry = self.countries[indexPath.row]
        
        cell.regionalNameLabel.text = currentCountry.country
        
        cell.regionalPercentageLabel.text = self.subRegion.convertFloatToString(currentCountry.proportion)
        
        return cell
      }
  
      // function to let you tap the cell and go to the subRegion page
      func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did select item") }
      
      // custom segue to go to the next page
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_CELEBS" {
          let destinationVC = segue.destinationViewController as CelebrityInterestViewController
//          let selectedIndexPath = self.tableView[indexPath.row].first as NSIndexPath  // <- not sure what the first does
          let selectedIndexPath = self.tableView.indexPathForSelectedRow()! as NSIndexPath
          //          let selectedIndexPath = self.tableView.indexPathsForSelectedItems().first as NSIndexPath  // <- not sure what the first does
          destinationVC.country = self.countries[selectedIndexPath.row]
        }
      }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.countries.count 
  }
      

        // Do any additional setup after loading the view.

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
