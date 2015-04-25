//
//  SubRegion.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

class SubRegion
{
  var region     : String
  var proportion : Float
  var unassigned : Float?
  var countries  : [[String:AnyObject]]?
  
  init(jsonDictionary: [String:AnyObject])
  {
    self.region     = jsonDictionary["label"] as! String
    let percentage  = jsonDictionary["proportion"] as! Float
    self.proportion = percentage * 100
    if let unknown  = jsonDictionary["unassigned"] as? Float
    {
      self.unassigned = unknown * 100
    }
    
    if let country = jsonDictionary["sub_populations"] as? [[String:AnyObject]]
    {
      self.countries = country
    }
  }
  
  //converts a float to a string
  func convertFloatToString(floatToConvert:Float) -> String
  {
    let stringConvert           = NSString(format: "%.2f", floatToConvert)
    let numberFormatter         = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    
    return numberFormatter.stringFromNumber(floatToConvert)!
  }
}