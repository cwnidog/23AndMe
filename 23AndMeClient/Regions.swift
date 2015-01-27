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
  var subRegions : [SubRegion]? // array of SubRegion objects storing the regions ie "European", "Asian"

  init(jsonDictionary : [String : AnyObject]) // will be passed a region dictionary that may contain sub
  {
    self.region     = jsonDictionary["label"] as String
    self.proportion = jsonDictionary["proportion"] as Float
    
    if let unknown = jsonDictionary["unassigned"] as? Float
    {
      self.unassigned = unknown
    }
    
    if let subRegion = jsonDictionary["sub_populations"] as? [[String:AnyObject]]
    {
      for item in subRegion
      {
        let sub = SubRegion(jsonDictionary: item)
      }
    }
  }
}
