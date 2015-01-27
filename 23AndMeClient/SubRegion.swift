//
//  SubRegion.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

class SubRegion {
  var region : String
  var proportion : Float
  var unassigned : Float?
  var countries  : [Country]?
  
  init(jsonDictionary: [String:AnyObject])
  {
    self.region = jsonDictionary["label"] as String
    self.proportion = jsonDictionary["proportion"] as Float
    if let unknown = jsonDictionary["unassigned"] as? Float
    {
      self.unassigned = unknown
    }
    if let country = jsonDictionary["sub_populations"] as? [[String:AnyObject]]
    {
      for item in country
      {
        let newCountry = Country(jsonDictionary: item)
        self.countries?.append(newCountry)
      }
    }
  }
}