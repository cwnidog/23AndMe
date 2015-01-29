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
  
  // OAuth properties
  let clientSecret = "25959db5672ef3b67399713f140c0302"
  let clientID = "98d783a58c22cc274221088f60e99d5e"
  
  let accessTokenUserDefaultsKey = "accessToken"
  let refreshTokenUserDefaultsKey = "refreshToken"
  let tokenStoredDateDefaultKey = "tokenStoredDate"
  let tokenTypeDefaultKey = "tokenType"
  let maternalDefaultKey = "maternal"
  let paternalDefaultKey = "paternal"
  
  var accessToken : String?
  var refreshToken : String?
  var tokenType : String?
  var needRefresh = false
  
  var userID : String? // the if for this user
  var profiles = [UserProfile]() // an array of all the prfiles associated with this user (mother, father, etc.)
  
  var urlSession : NSURLSession
  
  //store string variables associated with the users Haplogroups - paternal could remain nil
  var paternalHaplogroup : String?
  var maternalHaplogroup : String?
  
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
      
      //load stored user haplogroups - If user has an access token - then they should also have haplogroup data stored
      self.paternalHaplogroup = NSUserDefaults.standardUserDefaults().valueForKey(paternalDefaultKey) as? String
      self.maternalHaplogroup = NSUserDefaults.standardUserDefaults().valueForKey(maternalDefaultKey) as? String

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
  
  // MARK: handleCallbackURL
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
  
  func fetchAncestryComposition(profileID: String?, callback:(region:[Regions]?, errorString: String?) -> (Void))
  {
    let url = NSURL(string: "https://api.23andme.com/1/demo/ancestry/\(profileID!)/?threshold=0.9") //TODO: this is probably wrong!!
    println(url)
    let requestedURL = NSMutableURLRequest(URL: url!)
    requestedURL.setValue("\(self.tokenType!) \(self.accessToken!)", forHTTPHeaderField: "Authorization")
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
              //println(jsonData)
             if (error == nil)
             {
              var regions = [Regions]()
              if let ancestry = jsonData["ancestry"] as? [String:AnyObject] // "ancestry" could be nil TODO: add alertcontroler for this condition
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
  
  //MARK: fetchProfileID
  func fetchProfileID((), callback : ([UserProfile]?, String?, String?) -> (Void))
  {
    // set up the request
    let url = NSURL(string: "https://api.23andme.com/1/demo/user/")
    let request = NSMutableURLRequest(URL: url!)
    
    request.setValue("\(self.tokenType!) \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    println(request.allHTTPHeaderFields)
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200 ... 299 :
            // get the user's ID
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String:AnyObject] {
              if let userID = jsonDictionary["id"] as? String
              {
                self.userID = userID
              } // if let id
              
              // get the ID of any profiles associated with this user, e.g. parents, siblings, etc
              if let profilesArray = jsonDictionary["profiles"] as? [[String:AnyObject]] {
                // build the array of users
                for item in profilesArray
                {
                  let profile = UserProfile(jsonDictionary: item)
                  self.profiles.append(profile)
                } // for item
                
                // go back to the main thread and execute the callback
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(self.profiles, self.userID, nil)
                }) // enclosure
              } // if let items_array
            } // if let jsonDictionary
            
          case 400 ... 499:
            println("Got response saying error at our end with status code: \(httpResponse.statusCode)")
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String:AnyObject] {
              println(jsonDictionary)
            }
            
            
          case 500 ... 599:
            println("Got response saying error at server end with status code: \(httpResponse.statusCode)")
            
          default :
            println("Hit default case with status code: \(httpResponse.statusCode)")
          } // switch
        } // if let httpResponse
      } // error = nil
        
      else {
        println(error.localizedDescription) // what was the error?
      }
    }) // callback enclosure
    dataTask.resume()
  } // fetchUsersForSearchTerm()
  
  
  /*  MARK: fetchUserHaplogroup  -  this method will return a paternal(if available) and maternal  **
  **  haplogroup as 2 strings - these strings will be stored for future use using NSUserDefaults   */
  func fetchUserHaplogroup(profileID:String?, callback:(maternalHaplo:String?, paternalHaplo:String?, errorString: String?) -> (Void))
  {
    let url = NSURL(string: "https://api.23andme.com/1/haplogroups/\(profileID!)")
    let requestedURL = NSMutableURLRequest(URL: url!)
    requestedURL.setValue("\(self.tokenType) \(self.accessToken)", forHTTPHeaderField: "Authorization")
    let dataTask = self.urlSession.dataTaskWithRequest(requestedURL, completionHandler: { (data, response, error) -> Void in
      if(error == nil)
      {
        var error:NSError?
        var maternalHaplo:String?
        var paternalHaplo:String?
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String:AnyObject]
        {
          if(error == nil)
          {
            println(jsonData)
            for dictionary in jsonData
            {
              if let maternal = jsonData["maternal"] as? String
              {
                maternalHaplo = maternal
                println(maternalHaplo)
              } else if let paternal = jsonData["paternal"] as? String
              {
                println(paternalHaplo)
                paternalHaplo = paternal
              }
            }
          }
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            callback(maternalHaplo:maternalHaplo, paternalHaplo:paternalHaplo, errorString: nil)
          })
        }// jsonData
      }//if(error == nil)
    })//completionHandler
    dataTask.resume()
  }//fetchUserHaplogroup
  
} // NetworkController
