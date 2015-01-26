//
//  NetworkController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class NetworkController {
  
  // create a singleton NetworkController
  class var sharedNetworkController : NetworkController {
    struct Static {
      static let instance : NetworkController = NetworkController()
    }
    return Static.instance
  } // sharedNetworkController

  
} // NetworkController
