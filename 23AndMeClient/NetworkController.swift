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
  let tokenAgeOut = 82800
  
  var accessToken : String?
  var refreshToken : String?
  var needRefresh = false
  
  var urlSession : NSURLSession
  
  init()
  {
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
    // if we have a stored access token, that is less than a day old, use it
    if let accessToken = NSUserDefaults.standardUserDefaults().valueForKey(self.accessTokenUserDefaultsKey) as? String
    {
      let tokenDate = NSUserDefaults.standardUserDefaults().valueForKey(tokenStoredDateDefaultKey) as? NSDate
      
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
      
    } // if let accessToken
    
  } // init ()
  
  
  func handleCallbackURL(url : NSURL, completionHandler : () -> ())
  {
    var postRequest : NSMutableURLRequest!
    
    if !self.needRefresh // need to ask for an initial token
    {
      let code = url.query
      
      // send a POST back to 23AndMe asking for a token using the authorization code
      let bodyString = "client_id=\(self.clientID)&client_secret=\(self.clientSecret)&grant_type=authorization_code&\(code!)&redirect_uri=https://localhost:5000/receive_code/&scope=basic"
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
      postRequest = NSMutableURLRequest(URL : NSURL(string: "https://api.23andme.com/token/")!)
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
              let currentDate = NSDate()
              
              // store the access and refresh tokens away for reuse
              NSUserDefaults.standardUserDefaults().setValue(self.accessToken!, forKey: self.accessTokenUserDefaultsKey)
              NSUserDefaults.standardUserDefaults().setValue(self.refreshToken!, forKey: self.refreshTokenUserDefaultsKey)
              NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: self.tokenStoredDateDefaultKey)

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
  
  
} // NetworkController
