//
//  Celebrity.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/28/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

struct Celebrity
{
  var maleName : String
  var femaleName : String
  
  var maleUrl : String
  var femaleUrl : String
  
  init(celebrityNameDictionary: [String:AnyObject])
  {
    self.maleName    = celebrityNameDictionary["male"] as! String
    self.femaleName = celebrityNameDictionary["female"] as! String
    
    self.maleUrl = celebrityNameDictionary["maleImage"] as! String
    self.femaleUrl = celebrityNameDictionary["femaleImage"] as! String
  }
}