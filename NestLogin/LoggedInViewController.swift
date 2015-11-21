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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = accessTokenText
        
        LoggedInViewController.getAuthorizationToken()
        
        print("\(accessTokenText)")
        
        populateFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
