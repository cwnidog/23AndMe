//
//  CelebrityInterestViewController.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class CelebrityInterestViewController: UIViewController {
  
  // if a particular region does not contain a subregion and/or country -> will redirect here 
  var Region    : Regions?
  var subRegion : SubRegion?
  var country   : Country?
  
  var countryHeadlineLabel : String?
  
  var maleName : String?
  var femaleName : String?
  var maleImageUrl : String?
  var femaleImageUrl : String?
  var finalCountry : String?
  var countryDictionary = [String:AnyObject]()
  
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
      
      // println("CelebDictionary = \(celebDictionary)")
      
      // loop through each country dictionary
      
//      if country!.country != nil {
//        let finalCountry = country.country
//      } else if Region.region != nil {
//        let finalCountry = region.region
//      } else if subRegion.subRegion != nil {
//        let finalCountry = subRegion.subRegion
//      }
      
      var finalCountry = "Unassigned"
  
      self.countryDescriptionLabel.text = "Celebrities with \(finalCountry) Ancestory"

      var countryDictionary = celebDictionary![finalCountry] as [String : AnyObject]
      println("countryDictionary = \(countryDictionary)")
      self.celebrityMaleLabel.text = countryDictionary["male"] as? String
      self.celebrityFemaleLabel.text = countryDictionary["female"] as? String
      self.maleImageUrl = countryDictionary["maleImage"] as? String
      self.femaleImageUrl = countryDictionary["femaleImage"] as? String
      println("maleImageUrl = \(maleImageUrl)")
      
      requestImage()
      
  }
  
  
      // func didRequestImage(results: NSDictionary) {
      func requestImage() {
        var male_url = self.maleImageUrl
        println("male_url = \(male_url)")
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
        // self.collectionView.reloadData()
       // UIImageView.image.reloadData()

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
