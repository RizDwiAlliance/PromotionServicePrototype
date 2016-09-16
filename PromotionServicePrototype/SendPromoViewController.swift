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
    
    
    var url: URL? //url to be sent out in message
    
    var promo: Promotion?  //current promotion selected to be advertised
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promoMessageTextView.delegate = self;
        
        if let p = promo {
            
            //Change URL Label
            let urlParser = URLParser();
            url = urlParser.getURL(p) as URL;
            
            URLLabel.text = url?.description;
        }
        
        //set the alert promotion delegate to the current view
        gameController.promotionAlertDelegate = self;
    }
    
    
    // MARK: UITextViewDelegate
    
    //what happens when the text view controller is selected for editing
    func textViewDidBeginEditing(_ textView: UITextView) {
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
    func textViewDidEndEditing(_ textView: UITextView) {
        //hide keyboard
        promoMessageTextView.resignFirstResponder();
        //remove done button in the navigation bar
        navigation.rightBarButtonItem = nil;
        
    }
    
    // MARK: MFMessageViewControllerDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil);
    }
    
    // MARK: PromotionAlertDelegate
    
    func promotionRedeemed(_ promotion: Promotion) {
        //Display alert
        let message = "Congratulations, you're successfully redeemed \(promotion.promotionDescription) for \(promotion.reward) gold";
        let alert = UIAlertController(title: "Promotion Redeemed", message: message, preferredStyle: .alert);
        let action = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    func promotionRejected() {
        let alert = UIAlertController(title: "Promotion Rejected", message: "Your promotion is currently invalid", preferredStyle:  .alert);
        let action = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil);
    }
    
    // MARK: Navigation
    
    //function of cancel button in the navigation bar
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Button Actions
    
    //SMS button press
    @IBAction func sendBySMS(_ sender: UIButton) {
        sendMessage();
    }

    //Using MFMessageComposeViewController to send text
    func sendMessage() {
        //prepare text
        var text = promoMessageTextView.text!;
        
        //change url to add refer query item
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let referQueryItem = URLQueryItem(name: "refer", value: "SMS");
        urlComp?.queryItems?.append(referQueryItem);
        
        let urlString: String = "\n\n\(urlComp!.url!.description)";
        text += urlString;
        
        
        //Check if device can send texts
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController();  //create a new message compose view controller
            
            smsController.messageComposeDelegate = self;  //add current view as delegate
            smsController.body = text;  //set the body of the message
            
            self.present(smsController, animated: true, completion: nil);  //open the message compose view
        }
        else {
            print("Can't send texts");
            let errorAlert = UIAlertController(title: "Can't Send text", message: "Device can't send texts...", preferredStyle: .alert);
            let errorAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            errorAlert.addAction(errorAction);
            present(errorAlert, animated: true, completion: nil);
        }
    }
    
    //FB Button
    @IBAction func sendByFaceBook(_ sender: UIButton) {
        //TODO: Send message through facebook
        //sendOpenURL();
        sendByFacebook()
    }
    
    func sendByFacebook() {
        let body = promoMessageTextView.text;
        
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false);
        let referQueryItem = URLQueryItem(name: "refer", value: "FB");
        urlComp!.queryItems! += [referQueryItem];
        
        let facebookComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook);
        if !(facebookComposeViewController?.setInitialText(body))! {
            print("did not set text");
        }
        facebookComposeViewController?.add(urlComp!.url!);
        
        self.present(facebookComposeViewController!, animated: true, completion: nil);
    }
    
    //Twitter Button
    @IBAction func sendByTwitter(_ sender: AnyObject) {
        sendByTwitter();
    }
    
    func sendByTwitter(){
        let body = promoMessageTextView.text;
        
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false);
        let referQueryItem = URLQueryItem(name: "refer", value: "twt");
        urlComp!.queryItems! += [referQueryItem];
        
        let twitterComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter);
        if !(twitterComposeViewController?.setInitialText(body))! || !(twitterComposeViewController?.add(urlComp!.url!))!{
            print("Did not set text");
        }
        
        
        self.present(twitterComposeViewController!, animated: true, completion: nil);
    }
    
    
    
    //Create and open SMS url preloaded with text
    func sendOpenURL() {
        //add refer query to promotion URL
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let referQueryItem = URLQueryItem(name: "refer", value: "FB");
        urlComp!.queryItems! += [referQueryItem];
        
        //create text that will be sent in the body of the message
        var body = promoMessageTextView.text + "\n\n" + urlComp!.url!.description;
        body = prepBodyString(body);
        
        //Create URL that contains the message and open the URL
        let smsString = "sms://&body=\(body)";
        
        //ensure that the URL does not have invalid characters by encoding them with allowed characteres
        let escapedSMSString = smsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        
        //create NSURL object and open it
        let sms = URL(string: escapedSMSString);
        UIApplication.shared.openURL(sms!);
        
        
    }
    
    //Email Button
    @IBAction func emailButtonAction(_ sender: UIButton) {
        shareByEmail();
    }
    
    func shareByEmail(){
        if MFMailComposeViewController.canSendMail() {
            var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false);
            let referQueryItem = URLQueryItem(name: "refer", value: "Email");
            urlComp!.queryItems! += [referQueryItem];
            
            //let body = promoMessageTextView.text + "\n\n" + urlComp!.URL!.description;
            let body = "<p>\(promoMessageTextView.text)</p><p><a href=\"\(urlComp!.url!.description)\">\(promo!.promotionDescription)</a></p>";
            let subject = "Promotion Service (\(promo!.promotionDescription))";
            
            let emailController = MFMailComposeViewController();
            
            emailController.mailComposeDelegate = self;
            emailController.setMessageBody(body, isHTML: true);
            emailController.setSubject(subject);
            
            self.present(emailController, animated: true, completion: nil);
        }
        else {
            print("Can't send email");
            let errorAlert = UIAlertController(title: "Can't send email", message: "This device cannot send emails", preferredStyle: .alert);
            let errorAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            errorAlert.addAction(errorAction);
            present(errorAlert, animated: true, completion: nil);
        }
        
    }

    
    
    //encode special characters with url appropriate encodings
    func prepBodyString(_ b: String) -> String {
        var body = b.replacingOccurrences(of: "&", with: "%26");
        body = body.replacingOccurrences(of: "\n", with: "%0A");
        return body;
    }
}
