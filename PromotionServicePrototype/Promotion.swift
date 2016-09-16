//
//  Promotion.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import Foundation

class Promotion : NSObject {
    
    // MARK: Properties
    
    let promotionID : Int;
    let promotionDescription : String
    let startDate : Date;
    let endDate : Date?
    let reward : Int;
    let senderReward : Int;
    let VIPPromotion : Bool;
    
    //Property that determines whether the promotion is valid for redemption
    var isValid: Bool {
        //check if promotion has already been redeemed
        if !gameController.user!.promotionsRedeemed.contains(promotionID) {
            //check if today's date is valid
            let today = Date();
            if today.compare(startDate) == ComparisonResult.orderedDescending {  //if today is greater than promo start date
                if let endDate = endDate {  //if there is an end date to the promo
                    if today.compare(endDate) == ComparisonResult.orderedAscending {  //if today is less than promo end date
                        return true;
                    }
                }
                else {  //if there is no end date
                    return true;
                }
            }
        }
        else {
            print("Already Redeemed");
        }
    
        
        return false;
    }
    
    
    // MARK: Initializers
    init(promotionID: Int, promoDescription: String, startDate: Date, endDate: Date?, reward: Int, senderReward: Int, VIP: Bool) {
        self.promotionID = promotionID;
        self.promotionDescription = promoDescription;
        self.startDate = startDate;
        self.endDate = endDate;
        self.reward = reward;
        self.senderReward = senderReward;
        self.VIPPromotion = VIP;
    }
    
}
