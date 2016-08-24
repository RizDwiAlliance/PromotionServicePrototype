//
//  MainViewController.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, PromotionAlertDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var sendPromotionButton: UIButton!
    @IBOutlet weak var goldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //Add this view as an observer to events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.updateGold), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        //self the alert promotion delegate in the controller to this view
        gameController.promotionAlertDelegate = self;
        
        //game updates
        updateGold();
    }
    
    //updates the gold label with the current gold amount in gameController
    func updateGold() {
        let goldText = "Gold: \(gameController.gold)";
        goldLabel.text = goldText;
        print("user: \(gameController.user?.customerID) gold updated");
        
    }
    
    // MARK: Promotion Alert
    
    //Implementation of PromotionAlertProtocol
    
    func promotionRedeemed(promotion: Promotion) {
        //Display alert
        let message = "Congratulations, you're successfully redeemed \(promotion.promotionDescription) for \(promotion.reward) gold";
        let alert = UIAlertController(title: "Promotion Redeemed", message: message, preferredStyle: .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
        
        //update the gold label
        updateGold();
    }

    
    
    func promotionRejected() {
        //display alert
        let alert = UIAlertController(title: "Promotion Rejected", message: "Your promotion is currently invalid", preferredStyle:  .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    deinit {
        //remove observer from notification center when disposed
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
}
