//
//  Regions.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

class Regions
{
  var region     : String
  var proportion : Float
  var unassigned : Float?
  var subRegions : [[String:AnyObject]]? // array of SubRegion objects storing the regions ie "European", "Asian"

  init(jsonDictionary : [String : AnyObject]) // will be passed a region dictionary that may contain sub
  {
    self.region     = jsonDictionary["label"] as! String
    let percentage = jsonDictionary["proportion"] as! Float
    
    self.proportion = percentage * 100
    
    if let unknown  = jsonDictionary["unassigned"] as? Float
    {
      self.unassigned = unknown * 100
    }
    
    if let subRegionData = jsonDictionary["sub_populations"] as? [[String:AnyObject]]
    {
      self.subRegions = subRegionData
    }
  }
  
  //this method converts a float to a string
  func convertFloatToString(floatToConvert:Float) -> String
  {
    let stringConvert           = NSString(format: "%.2f", floatToConvert)
    let numberFormatter         = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    
    return numberFormatter.stringFromNumber(floatToConvert)!
  }
}
