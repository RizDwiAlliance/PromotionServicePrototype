//
//  File.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import Foundation

class GameController {
    
    //MARK: Properties
    
    //Gold amount
    var gold: Int {
        didSet {
            print("gold: \(gold)");
            user!.gold = gold;
        }
    }
    
    var user: UserPromotion?   //Current user of the game
    var users = [UserPromotion]();
    var availablePromotions = [Promotion]();  //Currently available promotions (downloaded from database)
    var promotionAlertDelegate: PromotionAlertDelegate?  //current delegate to handle promotion alerts
    
    //MARK: Constructors
    init() {
        gold = 0;
        
        //INitialize Game Controller with users to sign in
        loadUsers();
        
        loadPromotions();
        
        print("done");
        
    }
    
    //MARK: Methods
    
    //Creates users and stores them in users
    func loadUsers() {
        let defaultUser = UserPromotion(customerID: 101);
        defaultUser.promotionsRedeemed += [1, 3, 5];
        defaultUser.VIP = false;
        defaultUser.gold = 150;
        
        let VIPUser = UserPromotion(customerID: 1);
        VIPUser.promotionsRedeemed += [1, 2, 3, 4, 5];
        VIPUser.VIP = true;
        VIPUser.gold = 5000;
        
        users += [defaultUser, VIPUser];
    }
    
    //Creates promotions and stores them in availablePromotions
    //Ideally this would be downloaded from the database
    func loadPromotions() {
        
        let calendar = NSCalendar.currentCalendar();
        
        //Expired Promotion
        let promo1ID = 7;
        let promo1Description = "New Years Promotion";
        
        let promo1DateComp = NSDateComponents();
        promo1DateComp.day = 1;
        promo1DateComp.month = 1;
        promo1DateComp.year = 2016;
        promo1DateComp.timeZone = NSTimeZone(name: "PST");
        let promo1Date = calendar.dateFromComponents(promo1DateComp);
        
        let promo1End = NSDateComponents();
        promo1End.day = 14;
        promo1End.month = 1;
        promo1End.year = 2016;
        promo1End.timeZone = NSTimeZone(name: "PST");
        let promo1EndDate = calendar.dateFromComponents(promo1End);
        
        let promo1Reward = 500;
        let promo1SenderReward = 50;
        
        let promo1 = Promotion(promotionID: promo1ID, promoDescription: promo1Description, startDate: promo1Date!, endDate: promo1EndDate!, reward: promo1Reward, senderReward: promo1SenderReward, VIP: false);
        
        //New User Promotion
        let promo2ID = 1;
        let promo2Description = "New User";
        
        let promo2StartComp = NSDateComponents();
        promo2StartComp.day = 1;
        promo2StartComp.month = 1;
        promo2StartComp.year = 1997;
        promo2StartComp.timeZone = NSTimeZone(name: "PST");
        let promo2StartDate = calendar.dateFromComponents(promo2StartComp);
        
        let promo2Reward = 1000;
        let promo2SenderReward = 300;
        
        let promo2 = Promotion(promotionID: promo2ID, promoDescription: promo2Description, startDate: promo2StartDate!, endDate: nil, reward: promo2Reward, senderReward: promo2SenderReward, VIP: false);
        
        //Valid Promotion
        
        let promo10ID = 10;
        let promo10Description = "User Appreciation Reward";
        
        let promo10DateComp = NSDateComponents();
        promo10DateComp.day = 15;
        promo10DateComp.month = 3;
        promo10DateComp.year = 2016;
        promo10DateComp.timeZone = NSTimeZone(name: "PST");
        let promo10Date = calendar.dateFromComponents(promo1DateComp);
        
        let promo10End = NSDateComponents();
        promo10End.day = 14;
        promo10End.month = 1;
        promo10End.year = 2020;
        promo10End.timeZone = NSTimeZone(name: "PST");
        let promo10EndDate = calendar.dateFromComponents(promo1End);
        
        let promo10Reward = 1000;
        let promo10SenderReward = 100;
        
        let promo10 = Promotion(promotionID: promo10ID, promoDescription: promo10Description, startDate: promo10Date!, endDate: promo10EndDate!, reward: promo10Reward, senderReward: promo10SenderReward, VIP: false);
        
        //TODO: Create VIP Promotion and add to availablePromotions
        
        //VIP Promotion
        
        let promoVIPID = 100;
        let promoVIPDescription = "VIP Promotion";
        
        let promoVIPDateComp = NSDateComponents();
        promoVIPDateComp.day = 15;
        promoVIPDateComp.month = 3;
        promoVIPDateComp.year = 2016;
        promoVIPDateComp.timeZone = NSTimeZone(name: "PST");
        let promoVIPDate = calendar.dateFromComponents(promo1DateComp);
        
        let promoVIPEnd = NSDateComponents();
        promoVIPEnd.day = 14;
        promoVIPEnd.month = 1;
        promoVIPEnd.year = 2020;
        promoVIPEnd.timeZone = NSTimeZone(name: "PST");
        let promoVIPEndDate = calendar.dateFromComponents(promo1End);
        
        let promoVIPReward = 2000;
        let promoVIPSenderReward = 500;
        let promoVIP = Promotion(promotionID: promoVIPID, promoDescription: promoVIPDescription, startDate: promoVIPDate!, endDate: promoVIPEndDate!, reward: promoVIPReward, senderReward: promoVIPSenderReward, VIP: true);
        
        
        
         availablePromotions += [promo1, promo2, promo10, promoVIP];       
    }
    
    //Promotion is valid and needs to be awarded
    func awardPromotion(promo: Promotion, senderID: String?) {
        //update gold
        gold += promo.reward;
        
        //tell delegate to handle promotion redemption
        promotionAlertDelegate?.promotionRedeemed(promo);
        
        //TODO: send sender his sender reward
        if senderID != nil {
            print("Give user \(senderID) \(promo.senderReward) gold");
        }
        
    }
    
    //Promotion is invalid
    func rejectPromotion() {
        //tell delegate that a promotion has been rejected
        promotionAlertDelegate?.promotionRejected();
    }
    
    

    
}