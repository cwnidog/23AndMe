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
      let alertController = UIAlertController(title: "Genetic Profile", message: "Do you have a completed genetic profile at 23andMe? Note: if you do not have a profile and hit the \"Yes\" option, displays will be erratic", preferredStyle: .Alert)
      
      let noAction = UIAlertAction(title: "No", style: .Cancel) {(action) in println(action)
        self.navigationController?.popViewControllerAnimated(true)}
      alertController.addAction(noAction)
      
      let yesAction = UIAlertAction(title: "Yes", style: .Destructive) {(action) in NetworkController.sharedNetworkController.hasProfile = true
      self.navigationController?.popViewControllerAnimated(true)}
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
