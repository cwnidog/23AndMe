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
  
  let clientSecret = "25959db5672ef3b67399713f140c0302"
  let clientID = "98d783a58c22cc274221088f60e99d5e"
  
  let accessTokenUserDefaultsKey = "accessToken"
  let refreshTokenUserDefaultsKey = "refreshToken"
  let tokenStoredDateDefaultKey = "tokenStoredDate"
  let tokenTypeDefaultKey = "tokenType"
    
  var accessToken : String?
  var refreshToken : String?
  var tokenType : String?
  var needRefresh = false
  
  var urlSession : NSURLSession
  
  //use NSUSERDefaults to store these
  var userHaplogroups : [String : AnyObject]?
  
  init()
  {
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
    // if we have a stored access token, that is less than a day old, use it
    if let tempAccessToken = NSUserDefaults.standardUserDefaults().valueForKey(self.accessTokenUserDefaultsKey) as? String
    {
      self.accessToken = tempAccessToken
      let tokenDate = NSUserDefaults.standardUserDefaults().valueForKey(tokenStoredDateDefaultKey) as? NSDate
      self.tokenType = NSUserDefaults.standardUserDefaults().valueForKey(tokenTypeDefaultKey) as? String
      // check age of token
      let calendar = NSCalendar.currentCalendar()
      let now = NSDate()
    
      let components = calendar.components(NSCalendarUnit.HourCalendarUnit, fromDate: tokenDate!, toDate: now, options: nil)
      
      if components.hour > 23 // token timed out, need a new one
      {
        if let refreshToken = NSUserDefaults.standardUserDefaults().valueForKey(refreshTokenUserDefaultsKey) as? String
        {
          self.needRefresh = true // signal we need to refresh the access token
        } // if let refreshToken
      } // if components
    }
    // if let accessToken
  } // init ()
  
  
  func handleCallbackURL(url : NSURL, completionHandler : () -> ())
  {
    var postRequest : NSMutableURLRequest!
    
    if !self.needRefresh // need to ask for an initial token
    {
      let code = url.query
      
      // send a POST back to 23AndMe asking for a token using the authorization code
      let bodyString = "client_id=\(self.clientID)&client_secret=\(self.clientSecret)&grant_type=authorization_code&\(code!)&redirect_uri=http://localhost:5000/receive_code/&scope=basic"
      let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
      let length = bodyData!.length
      
      // put the POST request together
      postRequest = NSMutableURLRequest(URL : NSURL(string: "https://api.23andme.com/token/")!)
      postRequest.HTTPMethod = "POST"
      postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
      postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      postRequest.HTTPBody = bodyData
    } // need to ask for inital token
      
    else
    {
      // send a POST back to 23AndMe asking for a token using the refresh token
      let bodyString = "client_id=\(self.clientID)&client_secret=\(self.clientSecret)&grant_type=refresh_token&refresh_token=\(refreshToken)&redirect_uri=https://localhost:5000/receive_code/&scope=basic"
      let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
      let length = bodyData!.length
      
      // put the POST request together
      postRequest = NSMutableURLRequest(URL : NSURL(string: "http://api.23andme.com/token/")!)
      postRequest.HTTPMethod = "POST"
      postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
      postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      postRequest.HTTPBody = bodyData
      
    } // need to use refresh token
    
    // deal with the response
    let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil
      {
        // need to downcast the response as an NSHTTPURLResponse to read the status code
        if let httpResponse = response as? NSHTTPURLResponse
        {
          switch httpResponse.statusCode
          {
          case 200 ... 299 :
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            {
              self.accessToken = jsonDictionary["access_token"] as? String
              self.refreshToken = jsonDictionary["refresh_token"] as? String
              self.tokenType = jsonDictionary["token_type"] as? String
              let currentDate = NSDate()
              
              // store the access and refresh tokens away for reuse
              NSUserDefaults.standardUserDefaults().setValue(self.accessToken!, forKey: self.accessTokenUserDefaultsKey)
              NSUserDefaults.standardUserDefaults().setValue(self.refreshToken!, forKey: self.refreshTokenUserDefaultsKey)
              NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: self.tokenStoredDateDefaultKey)
              NSUserDefaults.standardUserDefaults().setValue(self.tokenType, forKey: self.tokenTypeDefaultKey)
              NSUserDefaults.standardUserDefaults().synchronize()
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler()
              })
            } // if let jsonDictionary
            
          case 400 ... 499 :
            println("Got response saying error at our end with status code: \(httpResponse.statusCode)")
            
          case 500 ... 599 :
            println("Got response saying error at server end with status code: \(httpResponse.statusCode)")
            
          default :
            println("Hit default case with status code: \(httpResponse.statusCode)")
          } // switch httpResponse.statusCode
        } // if let httpResponse
      } // if no error
    }) // end dataTask enclosure
    dataTask.resume()
  } // handleCallbackURL()
  
  
  func fetchAncestryComposition(userID: String?, callback:(region:[Regions]?, errorString: String?) -> (Void))
  {
    let url = NSURL(string: "https://api.23andme.com/1/ancestry/\(userID!)/?threshold=0.9") //TODO: this is probably wrong!!
    println(url)
    let requestedURL = NSMutableURLRequest(URL: url!)
    println("\(self.accessToken)")
    
    requestedURL.setValue("\(self.tokenType) \(self.accessToken)", forHTTPHeaderField: "Authorization")
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
                let ancestryRegion = ancestry["sub_populations"] as? [[String:AnyObject]]
                
                for region in ancestryRegion!
                {
                  let addRegion = Regions(jsonDictionary: region)
                  regions.append(addRegion)
                } // for region
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(region: regions, errorString: nil)
                }) // addOperationWithBlock enclosure
              } // if let ancestry
             } // if no error
            } // if let jsonData
          default:
            println(urlResponse.statusCode)
          } // switch
        } // if let urlResponse
      } // if no error
    }) // dataTask enclosure
    dataTask.resume()
  } // fetchAncestryComposition()

  
    
  /*
  func fetchUserHaplogroup(userID:String? callback:(haplogroup:[String:AnyObject]?, errorString: String?) -> (Void))
  {
    let url = NSURL(string: "https://api.23andme.com/1/haplogroups/\(userID)")
    let requestedURL = NSMutableURLRequest(URL: url!)
    requestedURL.setValue("\(self.tokenType) \(self.accessToken)", forHTTPHeaderField: "Authorization")
    let dataTask = self.urlSession.dataTaskWithRequest(requestedURL, completionHandler: { (data, response, error) -> Void in
      if(error == nil)
      {
        var haplogroup: [String:AnyObject]
        
      }
    })
    dataTask.resume()
    
  }
  */
  
  
} // NetworkController
