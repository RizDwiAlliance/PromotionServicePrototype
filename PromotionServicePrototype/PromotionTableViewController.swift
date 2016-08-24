//
//  PromotionTableViewController.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/10/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import UIKit

class PromotionTableViewController: UITableViewController, PromotionAlertDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var cancelButton: UINavigationItem!
    
    var Promotions = [Promotion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the promotionalert delegate to this view
        gameController.promotionAlertDelegate = self;
        
        //load Promotions
        for promo in gameController.availablePromotions {
            if promo.VIPPromotion {
                if gameController.user!.VIP! {
                    Promotions += [promo];
                }
            }
            else {
                Promotions += [promo];
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows        
        return Promotions.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PromotionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PromotionTableViewCell

        // Configure the cell...
        
        let promo = Promotions[indexPath.row];
        cell.promotionCellLabel.text = "\(promo.promotionDescription)";
        cell.rewardLabel.text = "Reward: \(promo.reward)";
        cell.senderRewardLabel.text = "Sender Reward: \(promo.senderReward)";
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: Promotion Alert
    
    //Implementation of PromotionAlertProtocol
    
    func promotionRedeemed(promotion: Promotion) {
        //Display alert
        let message = "Congratulations, you're successfully redeemed \(promotion.promotionDescription) for \(promotion.reward) gold";
        let alert = UIAlertController(title: "Promotion Redeemed", message: message, preferredStyle: .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func promotionRejected() {
        //display alert
        let alert = UIAlertController(title: "Promotion Rejected", message: "Your promotion is currently invalid", preferredStyle:  .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SendPromo" {
            
            let sendPromoViewController = segue.destinationViewController as! SendPromoViewController;
            
            //get cell that generated the view
            if let selectedPromoCell = sender as? PromotionTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedPromoCell)!
                let selectedPromo = gameController.availablePromotions[indexPath.row];
                sendPromoViewController.promo = selectedPromo;
            }
        }
    }

    

}
