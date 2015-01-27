//
//  AncestoryCatagory.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/26/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

struct GlobalCatagory {
  let globalName : String
  let globalNamePercentage : String // <- could also be Int?
  
  init (jsonDictionary : [String : AnyObject]) {
    self.globalName = jsonDictionary["placeholder'"] as String
    self.globalNamePercentage = jsonDictionary["placeholder2"] as String
  }
}


