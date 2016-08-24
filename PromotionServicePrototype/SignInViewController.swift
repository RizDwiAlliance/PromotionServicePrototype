//
//  SignInViewController.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/21/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var RegularUser: UIButton!
    @IBOutlet weak var VIPUser: UIButton!    
    
    // MARK: Actions
    
    func regularSignIn() {
        gameController.user = gameController.users[0];
        print("\(gameController.user!.customerID) signed in");
        gameController.gold = gameController.user!.gold;
    }
    
    
    func VIPSignIn() {
        gameController.user = gameController.users[1];
        print("\(gameController.user!.customerID) signed in");
        gameController.gold = gameController.user!.gold;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "regularUserSegue" {
            regularSignIn();
        }
        else if segue.identifier == "VIPUserSegue" {
            VIPSignIn();
        }
    }
}
