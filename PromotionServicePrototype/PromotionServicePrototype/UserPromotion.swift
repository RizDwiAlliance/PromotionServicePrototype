//
//  User.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import Foundation

class UserPromotion : NSObject {
    
    // MARK: Properties
    
    let customerID : Int?
    let guestAccountID : String?
    var VIP : Bool?
    var promotionsRedeemed = [Int]();  //the promotionIDs of promotions redeemed
    var gold: Int;
    
    
    // MARK: Initializers
    
    init(customerID : Int) {
        self.customerID = customerID;
        guestAccountID = nil;
        VIP = false;
        gold = 0;
    }
    
    init(guestAccountID : String) {
        self.guestAccountID = guestAccountID;
        customerID = nil;
        VIP = false;
        gold = 0;
    }
    
}
