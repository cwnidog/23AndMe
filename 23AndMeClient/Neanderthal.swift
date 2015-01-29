//
//  Neanderthal.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/29/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class Neanderthal
{
  var proportion : String!
  var ancestry :  String!
  var average : String!
  var percentile : Int!
  
  // initalize the properties from the JSON received from 23AndMe
  init(jsonDictionary : [String : AnyObject])
  {
    var rawProportion = jsonDictionary["proportion"] as Float
    proportion = self.convertFloatToString(rawProportion * 100) + "%"
    /*ancestry = jsonDictionary["ancestry"] as String
    average = jsonDictionary["average"] as String
    percentile = jsonDictionary["percentile"] as Int */
  } // init()
  
  //this function will convert its float parameter into a string
  func convertFloatToString(floatToConvert:Float) -> String
  {
    let stringConvert           = NSString(format: "%.2f", floatToConvert)
    let numberFormatter         = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    
    return numberFormatter.stringFromNumber(floatToConvert)!
  }

} // Neanderthal
