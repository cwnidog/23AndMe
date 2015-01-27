//
//  AncestryRegional.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

struct RegionalCatagory {
  let regionalName : String
  let regionalNamePercentage : String // <- could also be Int?
  
  init (jsonDictionary : [String : AnyObject]) {
    self.regionalName = jsonDictionary["placeholder'"] as String
    self.regionalNamePercentage = jsonDictionary["placeholder2"] as String
  }
}
