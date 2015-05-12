//
//  GeneticProfileViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 4/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class GeneticProfileViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      
      // find out if the user has a completed genetic profile before dismissing the view
      let alertController = UIAlertController(title: "Genetic Profile", message: "Do you have genetic profile results from 23andMe? \n \n Note: If you do not have genetic results from 23andMe, please pick \"No\" and you will be given sample data. \n \n A \"Yes\" option without 23andMe will display erratic data", preferredStyle: .Alert)
      
        
      let noAction = UIAlertAction(title: "No", style: .Cancel) {(action) in println(action)
        self.navigationController?.popToRootViewControllerAnimated(true)}
      alertController.addAction(noAction)
      
      let yesAction = UIAlertAction(title: "Yes", style: .Destructive) {(action) in NetworkController.sharedNetworkController.hasProfile = true
      self.navigationController?.popToRootViewControllerAnimated(true)}
      alertController.addAction(yesAction)
      
      self.presentViewController(alertController, animated: true) {}

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
