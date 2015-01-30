//
//  NeanderthalAncestryViewController.swift
//  23AndMeClient
//
//  Created by John Leonard on 1/25/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class NeanderthalAncestryViewController: UIViewController {

  @IBOutlet weak var NeanderthalImage: UIImageView!
  @IBOutlet weak var percentageNeanderthalLabel: UILabel!
  
  let neanderthalImage = UIImage(named: "neanderthalImage") // use a stored image to save time
  
    override func viewDidLoad()
    {
      super.viewDidLoad()
      NetworkController.sharedNetworkController.fetchNeanderthal((), { (neanderDict, error) -> (Void) in
        //initialize a Neanderthal with the provided JSON data
        var neanderthal = Neanderthal(jsonDictionary: neanderDict)
        
        // display the data
        self.NeanderthalImage.image = self.neanderthalImage
        self.percentageNeanderthalLabel.text = neanderthal.proportion
      }) // callback enclosure
    } // viewDidLoad()

} // NeanderthalAncestryViewController()
