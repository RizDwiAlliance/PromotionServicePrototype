//
//  URLParser.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import Foundation

//Class that reads URLs and handles the appropriately
class URLParser : NSObject {
    
    //generate a valid URL that can be sent in a message
    func getURL(_ promo: Promotion) -> URL {
        
        var url = URLComponents();
        url.scheme = "PromotionService";
        let senderQueryItem = URLQueryItem(name: "sender", value: gameController.user!.customerID?.description);
        let promoQueryItem = URLQueryItem(name: "promoID", value: promo.promotionID.description);
        
        url.queryItems = [senderQueryItem, promoQueryItem];
        url.path = "/promotion"
        url.host = ""
        
        return url.url!;
    }
    
    //returns a string of the promotion URL
    func getURLString(_ promotion: Promotion) -> String {
        let url = getURL(promotion);
        return url.description;
    }
    
    //Finds the promotion in the available promotions
    func getPromotionFromID(_ id: Int) -> Promotion? {
        let promotions = gameController.availablePromotions;
        
        for p in promotions {
            if p.promotionID == id {
                return p;
            }
        }
        
        return nil;
    }
    
    
    func checkURL(_ url: URL) {
        if let urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false) { //create a NSURLComponents from NSURL
            
            //if url is promo url
            if url.path == "/promotion" {
                if let queryItems = urlComp.queryItems {
                    //find the promoID from the URL, find the query item
                    if let promoQueryItem = queryItems.filter({$0.name == "promoID"}).first {
                        //get the value of the promoID from the query item
                        if let promo = getPromotionFromID(Int(promoQueryItem.value!)!) {
                            //check if promotion is valid
                            if promo.isValid {
                                
                                //get the senderID
                                var senderID: String?
                                if let senderQueryItem = queryItems.filter({$0.name == "sender"}).first {
                                    senderID = senderQueryItem.value!;
                                }
                                
                                //award the promotion
                                gameController.awardPromotion(promo, senderID: senderID);
                                //add the promotion into the list of promotions the user has redeemed
                                gameController.user!.promotionsRedeemed += [promo.promotionID];
                                
                            }
                            else {  //promotion is invalid for redemption
                                print("Promotion date is invalid");
                                gameController.rejectPromotion();
                            }
                        }
                        else {
                            //promotion not found
                            print("Promotion is invalid! (not found)");
                            gameController.rejectPromotion();
                        }
                    }
                
                }
            }
            
        }
        
    
    }
    
}
