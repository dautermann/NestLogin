//
//  LoggedInViewController.swift
//  NestLogin
//
//  Created by Michael Dautermann on 11/20/15.
//  Copyright © 2015 Michael Dautermann. All rights reserved.
//

import UIKit
import Foundation

class LoggedInViewController: UIViewController {

    var accessTokenText : String = ""
    
    @IBOutlet var authTokenLabel : UILabel!
    @IBOutlet var expirationDateLabel : UILabel!
    @IBOutlet var textView : UITextView!
    
    // hey hey, it's a class / static method!
    class func getAuthorizationToken() -> String? {
    
        let ud  = NSUserDefaults()

        if let expirationDate = ud.objectForKey("expiration_date") as? NSDate {
    
            let timeInterval = NSDate().timeIntervalSinceDate(expirationDate)
            
            if timeInterval < 0 {
                return ud.objectForKey("access_token") as? String
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Logout", style:.Plain, target:self, action:"logout:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        textView.text = accessTokenText
        
        LoggedInViewController.getAuthorizationToken()
        
        print("\(accessTokenText)")
        
        populateFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func logout(sender: UIBarButtonItem) {
        
        if let accessToken = LoggedInViewController.getAuthorizationToken() {
            let url = NSURL(string: "https://api.home.nest.com/oauth2/access_tokens/\(accessToken)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "DELETE"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if let error = error {
                    print("error while deleting tokens in \(error.localizedDescription)")
                } else {
                    var statusCode : Int = 204 // start off with 204 - No Content, which is what a DELETE call returns when the server fulfills the request
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        statusCode = httpResponse.statusCode
                    }

                    let ud = NSUserDefaults.standardUserDefaults()
                    ud.removeObjectForKey("expiration_date")
                    ud.removeObjectForKey("access_token")

                    if(statusCode != 204) {
                        print("Error could not delete token on Nest's servers \(statusCode)")
                    }
                    
                    // need to do UI things on main thread
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.navigationController?.popViewControllerAnimated(true)
                    }

                }
            })
            task.resume()
        }
    }
    

    
    func populateFields()
    {
        let ud  = NSUserDefaults()
        
        let expirationDate = ud.objectForKey("expiration_date") as! NSDate
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.timeZone = NSTimeZone.localTimeZone() // are we in EST or PST??
        let localTimeString = formatter.stringFromDate(expirationDate);
        
        expirationDateLabel.text = localTimeString

        let authTokenString = ud.objectForKey("access_token") as! String
        authTokenLabel.text = authTokenString
        
    }
    
}
