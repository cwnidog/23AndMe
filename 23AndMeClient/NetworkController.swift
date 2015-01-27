//
//  NetworkController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class NetworkController
{
  
  // create a singleton NetworkController
  class var sharedNetworkController : NetworkController
  {
    struct Static
    {
      static let instance : NetworkController = NetworkController()
    }
    return Static.instance
  } // sharedNetworkController

  let urlSession = NSURLSession()

  
  
  func fetchAncestryComposition(userID: String, callback:(region:[Regions]?, errorString: String?) -> (Void))
  {
    
    let url = NSURL(string: "https://api.23andme.com/1/user/1/ancestry/profile_id/?=\(userID)") //TODO: this is probably wrong!!
    let requestedURL = NSMutableURLRequest(URL: url!)
    requestedURL.setValue("token"/* TODO:add access token here*/, forHTTPHeaderField: "Authorization")
    
    let dataTask = self.urlSession.dataTaskWithRequest(requestedURL, completionHandler: { (data, response, error) -> Void in
      if(error == nil)
      {
        if let urlResponse = response as? NSHTTPURLResponse
        {
          switch urlResponse.statusCode
          {
          case 200...299:
            println(urlResponse.statusCode)
            var error:NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String:AnyObject]
            {
             if (error == nil)
             {
              var regions = [Regions]()
              if let ancestry = jsonData["ancestry"] as? [String:AnyObject] // "ancestry" could be nil TODO: add alertcontroler for this condition
              {
                let ancestryRegion = ancestry["sub_populations"] as [[String:AnyObject]]
                
                for region in ancestryRegion
                {
                  let addRegion = Regions(jsonDictionary: region)
                  regions.append(addRegion)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(region: regions, errorString: nil)
                })
              }
             }
            }
          default:
            println(urlResponse.statusCode)
          }
        }
      }
    })
  }
} // NetworkController
