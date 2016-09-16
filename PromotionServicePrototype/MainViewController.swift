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
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateGold), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
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
    
    func promotionRedeemed(_ promotion: Promotion) {
        //Display alert
        let message = "Congratulations, you're successfully redeemed \(promotion.promotionDescription) for \(promotion.reward) gold";
        let alert = UIAlertController(title: "Promotion Redeemed", message: message, preferredStyle: .alert);
        let action = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
        
        //update the gold label
        updateGold();
    }

    
    
    func promotionRejected() {
        //display alert
        let alert = UIAlertController(title: "Promotion Rejected", message: "Your promotion is currently invalid", preferredStyle:  .alert);
        let action = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    deinit {
        //remove observer from notification center when disposed
        NotificationCenter.default.removeObserver(self);
    }
    
}
