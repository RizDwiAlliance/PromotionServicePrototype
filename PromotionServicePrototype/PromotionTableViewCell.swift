//
//  PromotionTableViewCell.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/15/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var promotionCellLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var senderRewardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
