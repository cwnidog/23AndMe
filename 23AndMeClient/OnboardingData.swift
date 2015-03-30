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
  let text0 = "Welcome to CelebreMe23! This application allows you to import your 23andMe ancestry information and match it across a database of celebrity ancestries.  \n \n *** Note *** if you have not completed your profile, CelebriMe23 will display sample data from 23andMe and it will not be possible to explore parental haplogroups. \n \n Swipe to proceed!"
  let text1 = "Explore your maternal and paternal haplogroups and see what percentage your DNA is of neanderthal origin."
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