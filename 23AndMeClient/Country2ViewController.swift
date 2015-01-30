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

  override func viewDidLoad()
  {
    super.viewDidLoad()
      
    self.tableView.dataSource = self
    self.tableView.delegate   = self
    
    if let countryData = self.subRegion.countries
    {
      for country in countryData
      {
        let item = Country(jsonDictionary: country)
        self.countries.append(item)
      }
      self.tableView.reloadData()
    }
    
    self.tableView.registerNib(UINib(nibName: "GlobalCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "GLOBAL_CELL")
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("GLOBAL_CELL", forIndexPath: indexPath) as GlobalCell
        
    let currentCountry = self.countries[indexPath.row]
        
    cell.globalLabel.text = currentCountry.country
        
    cell.globalProportion.text = self.subRegion.convertFloatToString(currentCountry.proportion) + "%"
    
    cell.countryImage.image = UIImage(named: "country\(indexPath.row)")
    
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
  
      // function to let you tap the cell and go to the subRegion page
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    let countryToCelbrity = self.countries[indexPath.row]
    
    let toCelebrityVC = storyboard?.instantiateViewControllerWithIdentifier("CELEBRITY_VC") as CelebrityInterestViewController
    
    toCelebrityVC.country = countryToCelbrity
    
    self.navigationController?.pushViewController(toCelebrityVC, animated: true)
    
    
  }
      
      // custom segue to go to the next page
     /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_CELEBS" {
          let destinationVC = segue.destinationViewController as CelebrityInterestViewController
      //let selectedIndexPath = self.tableView[indexPath.row].first as NSIndexPath  // <- not sure what the first does
          let selectedIndexPath = self.tableView.indexPathForSelectedRow()! as NSIndexPath
          //          let selectedIndexPath = self.tableView.indexPathsForSelectedItems().first as NSIndexPath  // <- not sure what the first does
          destinationVC.country = self.countries[selectedIndexPath.row]
        }
      }*/
  
  
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
