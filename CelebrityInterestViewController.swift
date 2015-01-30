//
//  CelebrityInterestViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class CelebrityInterestViewController: UIViewController {
  
  var country : Country!
  
  var countryHeadlineLabel : String?
  
  var maleName : String?
  var femaleName : String?
  var maleImageUrl : String?
  var femaleImageUrl : String?
  
//  var celebCountry : CelebrityNameDictionaryDemo  // calls the celebArray content array I made

  @IBOutlet weak var countryDescriptionLabel: UILabel!
  
  @IBOutlet weak var celebrityMaleImage: UIImageView!
  @IBOutlet weak var celebrityFemaleImage: UIImageView!
  
  @IBOutlet weak var celebrityMaleLabel: UILabel!
  @IBOutlet weak var celebrityFemaleLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Plist code -> swift dictionary
      let path = NSBundle.mainBundle().pathForResource("CelebPropertyList", ofType: "plist") // creates a path to get the plist
      let celebDictionary = NSDictionary(contentsOfFile: path!) // creates the dictionary out of the plist
      
      // loop through each country dictionary
      
      self.countryDescriptionLabel.text = "Celebrities with \(country.country) Ancestory"

      let countryDictionary = celebDictionary![country.country] as [String : AnyObject]
      self.celebrityMaleLabel.text = countryDictionary["male"] as? String
      self.celebrityFemaleLabel.text = countryDictionary["female"] as? String
  }
    
//      var maleName = celebDictionary?.valueForKey("male") as? String
//      var femaleName = celebDictionary?.valueForKey("female") as? String
//      var maleImageUrl = celebDictionary?.valueForKey("maleImage") as? String
//      var femaleImageUrl = celebDictionary?.valueForKey("femaleImage") as? String

      
      
      
      
      // if the country name passed from the previous view controller matches the CelebDicitonary Key for country, then put on labels and images
//      For celebCountry in celebDicitonary {
//      if country == celebCountry {
//        
//        self.celebrityMaleLabel.text = self.celebDicionaty.maleName
//        self.celebrityFemaleLabel.text = self.celebDicionary.femalName
      

        
        
//         self.celebrityFemaleImage.image =
//         self.celebrityMaleImage.image =
        
        
 
      // put this into networkController?????
      
      func didRequestImage(results: NSDictionary) {
        var male_url = self.maleImageUrl
        var female_url = self.femaleImageUrl
        var mUrl = NSURL(string: male_url!)
        var fUrl = NSURL(string: female_url!)
        var maleImage: UIImage?
        var femaleImage: UIImage?
        var mRequest: NSURLRequest = NSURLRequest(URL: mUrl!)
        var fRequest: NSURLRequest = NSURLRequest(URL: fUrl!)
        
        NSURLConnection.sendAsynchronousRequest(mRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
          maleImage = UIImage(data: data)
          self.celebrityMaleImage.image = maleImage
          })
          NSURLConnection.sendAsynchronousRequest(fRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            femaleImage = UIImage(data: data)
            self.celebrityFemaleImage.image = femaleImage
        })
      }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
