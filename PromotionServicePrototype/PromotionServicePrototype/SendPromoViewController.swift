//
//  SendPromoViewController.swift
//  PromotionServicePrototype
//
//  Created by Rizky Ramdhani on 8/15/16.
//  Copyright © 2016 FiscalHoldingsLLC. All rights reserved.
//

import UIKit
import MessageUI
import Social

class SendPromoViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, PromotionAlertDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var promoMessageTextView: UITextView!
    @IBOutlet weak var URLLabel: UILabel!
    @IBOutlet weak var promoTitle: UILabel!
    @IBOutlet weak var FaceBookButton: UIButton!
    @IBOutlet weak var SMSButton: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var EmailButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    
    
    var url: NSURL? //url to be sent out in message
    
    var promo: Promotion?  //current promotion selected to be advertised
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promoMessageTextView.delegate = self;
        
        if let p = promo {
            
            //Change URL Label
            let urlParser = URLParser();
            url = urlParser.getURL(p);
            
            URLLabel.text = url?.description;
        }
        
        //set the alert promotion delegate to the current view
        gameController.promotionAlertDelegate = self;
    }
    
    
    // MARK: UITextViewDelegate
    
    //what happens when the text view controller is selected for editing
    func textViewDidBeginEditing(textView: UITextView) {
        //add a done button to the navigation bar to hide the keyboard when the user is done editing
        let doneButton = UIBarButtonItem();
        //done button properties
        doneButton.title = "Done";
        doneButton.target = self;
        doneButton.action = #selector(SendPromoViewController.endEdit);
        navigation.rightBarButtonItem = doneButton;
        
    }
    
    //hide the keyboard when user is done editing
    func endEdit() {
        promoMessageTextView.resignFirstResponder();
    }
    
    //what happens when the user is done editing the textView control
    func textViewDidEndEditing(textView: UITextView) {
        //hide keyboard
        promoMessageTextView.resignFirstResponder();
        //remove done button in the navigation bar
        navigation.rightBarButtonItem = nil;
        
    }
    
    // MARK: MFMessageViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: PromotionAlertDelegate
    
    func promotionRedeemed(promotion: Promotion) {
        //Display alert
        let message = "Congratulations, you're successfully redeemed \(promotion.promotionDescription) for \(promotion.reward) gold";
        let alert = UIAlertController(title: "Promotion Redeemed", message: message, preferredStyle: .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func promotionRejected() {
        let alert = UIAlertController(title: "Promotion Rejected", message: "Your promotion is currently invalid", preferredStyle:  .Alert);
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: Navigation
    
    //function of cancel button in the navigation bar
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Button Actions
    
    //SMS button press
    @IBAction func sendBySMS(sender: UIButton) {
        sendMessage();
    }

    //Using MFMessageComposeViewController to send text
    func sendMessage() {
        //prepare text
        var text = promoMessageTextView.text;
        
        //change url to add refer query item
        let urlComp = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false)
        let referQueryItem = NSURLQueryItem(name: "refer", value: "SMS");
        urlComp?.queryItems?.append(referQueryItem);
        
        let urlString: String = "\n\n\(urlComp!.URL!.description)";
        text.appendContentsOf(urlString);
        
        
        //Check if device can send texts
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController();  //create a new message compose view controller
            
            smsController.messageComposeDelegate = self;  //add current view as delegate
            smsController.body = text;  //set the body of the message
            
            self.presentViewController(smsController, animated: true, completion: nil);  //open the message compose view
        }
        else {
            print("Can't send texts");
            let errorAlert = UIAlertController(title: "Can't Send text", message: "Device can't send texts...", preferredStyle: .Alert);
            let errorAction = UIAlertAction(title: "OK", style: .Default, handler: nil);
            errorAlert.addAction(errorAction);
            presentViewController(errorAlert, animated: true, completion: nil);
        }
    }
    
    //FB Button
    @IBAction func sendByFaceBook(sender: UIButton) {
        //TODO: Send message through facebook
        //sendOpenURL();
        sendByFacebook()
    }
    
    func sendByFacebook() {
        let body = promoMessageTextView.text;
        
        let urlComp = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false);
        let referQueryItem = NSURLQueryItem(name: "refer", value: "FB");
        urlComp!.queryItems! += [referQueryItem];
        
        let facebookComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook);
        if !facebookComposeViewController.setInitialText(body) {
            print("did not set text");
        }
        facebookComposeViewController.addURL(urlComp!.URL!);
        
        self.presentViewController(facebookComposeViewController, animated: true, completion: nil);
    }
    
    //Twitter Button
    @IBAction func sendByTwitter(sender: AnyObject) {
        sendByTwitter();
    }
    
    func sendByTwitter(){
        let body = promoMessageTextView.text;
        
        let urlComp = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false);
        let referQueryItem = NSURLQueryItem(name: "refer", value: "twt");
        urlComp!.queryItems! += [referQueryItem];
        
        let twitterComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter);
        if !twitterComposeViewController.setInitialText(body) || !twitterComposeViewController.addURL(urlComp!.URL!){
            print("Did not set text");
        }
        
        
        self.presentViewController(twitterComposeViewController, animated: true, completion: nil);
    }
    
    
    
    //Create and open SMS url preloaded with text
    func sendOpenURL() {
        //add refer query to promotion URL
        let urlComp = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false)
        let referQueryItem = NSURLQueryItem(name: "refer", value: "FB");
        urlComp!.queryItems! += [referQueryItem];
        
        //create text that will be sent in the body of the message
        var body = promoMessageTextView.text + "\n\n" + urlComp!.URL!.description;
        body = prepBodyString(body);
        
        //Create URL that contains the message and open the URL
        let smsString = "sms://&body=\(body)";
        
        //ensure that the URL does not have invalid characters by encoding them with allowed characteres
        let escapedSMSString = smsString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        
        //create NSURL object and open it
        let sms = NSURL(string: escapedSMSString);
        UIApplication.sharedApplication().openURL(sms!);
        
        
    }
    
    //Email Button
    @IBAction func emailButtonAction(sender: UIButton) {
        shareByEmail();
    }
    
    func shareByEmail(){
        if MFMailComposeViewController.canSendMail() {
            let urlComp = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false);
            let referQueryItem = NSURLQueryItem(name: "refer", value: "Email");
            urlComp!.queryItems! += [referQueryItem];
            
            //let body = promoMessageTextView.text + "\n\n" + urlComp!.URL!.description;
            let body = "<p>\(promoMessageTextView.text)</p><p><a href=\"\(urlComp!.URL!.description)\">\(promo!.promotionDescription)</a></p>";
            let subject = "Promotion Service (\(promo!.promotionDescription))";
            
            let emailController = MFMailComposeViewController();
            
            emailController.mailComposeDelegate = self;
            emailController.setMessageBody(body, isHTML: true);
            emailController.setSubject(subject);
            
            self.presentViewController(emailController, animated: true, completion: nil);
        }
        else {
            print("Can't send email");
            let errorAlert = UIAlertController(title: "Can't send email", message: "This device cannot send emails", preferredStyle: .Alert);
            let errorAction = UIAlertAction(title: "OK", style: .Default, handler: nil);
            errorAlert.addAction(errorAction);
            presentViewController(errorAlert, animated: true, completion: nil);
        }
        
    }

    
    
    //encode special characters with url appropriate encodings
    func prepBodyString(b: String) -> String {
        var body = b.stringByReplacingOccurrencesOfString("&", withString: "%26");
        body = body.stringByReplacingOccurrencesOfString("\n", withString: "%0A");
        return body;
    }
}