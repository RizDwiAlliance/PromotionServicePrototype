//
//  PromotionAlertDelegate.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/16/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import Foundation

//protocol that allows handlers to handle promotion alerts
protocol PromotionAlertDelegate {
    func promotionRedeemed(promotion: Promotion);
    func promotionRejected()
}