//
//  File.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/28/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class UserProfile
{
  var genotyped : Bool
  var profileID : String
  
  init(jsonDictionary : [String : AnyObject])
  {
    genotyped = jsonDictionary["genotyped"] as Bool
    profileID = jsonDictionary["id"] as String
  } // init()
} // UserProfile
