//
//  PageContentViewController.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
  @IBOutlet weak var nextButton: UIButton!

  @IBOutlet weak var pageText: UITextView!
  @IBOutlet weak var pageImage: UIImageView!
  @IBAction func nextPageClicked(sender: UIButton)
  {
    println("next page clicked")
    
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  let onboardingInfo      = OnboardingData()
  
  var hideButton : Bool   = false
  var itemIndex  : Int    = 0
  var imageName  : String = "default"
    {
    didSet
    {
      if let imageView = pageImage
      {
        imageView.image = UIImage(named: imageName)
      }
    }
  }
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()

    pageImage.image = UIImage(named: imageName)
    self.nextButton.hidden   = self.hideButton
    self.pageText.text = self.onboardingInfo.getText(self.itemIndex)
    
  }
  
}
