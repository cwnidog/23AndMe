//
//  OnboardingData.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 2/19/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import Foundation

class OnboardingData
{
  let text0 = "Welcome to CelebreMe23! Swipe to continue!"
  let text1 = "We will import your profile from your 23andMe account and match it across a database of celebrity ancestries. If you have completed your profile, you can  explore your own genetic heritage, else you will see sample data from 23andMe, which does not include parental haplogroups."
  let text2 = "Once you have discovered your celebrity kin-folk, share it with your friends on twitter or facebook!"
  let text3 = "But first we will need you to sign into your 23andme account so we can find out if you have stars in your genes!"
  
  func getText(index:Int) -> String
  {
    let myText = [text0, text1, text2, text3]
    
    for (var i = 0; i < myText.count; i++)
    {
      if (i == index)
      {
        return myText[index] as String
      }
    }
    return "string not found"
  }
}