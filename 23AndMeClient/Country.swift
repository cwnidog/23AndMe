//
//  Country.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

class Country
{
  var country    : String
  var proportion : Float
  
  init(jsonDictionary: [String:AnyObject])
  {
    self.country    = jsonDictionary["label"] as String
    self.proportion = jsonDictionary["proportion"] as Float
  }
}