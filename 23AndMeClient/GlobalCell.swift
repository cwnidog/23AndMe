//
//  GlobalCell.swift
//  23AndMeClient
//
//  Created by Annemarie Ketola on 1/27/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

class GlobalCell: UITableViewCell
{

  @IBOutlet weak var countryImage     : UIImageView!
  @IBOutlet weak var globalLabel      : UILabel!
  @IBOutlet weak var globalProportion : UILabel!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
  }
}
