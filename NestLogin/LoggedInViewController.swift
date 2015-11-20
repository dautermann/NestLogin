//
//  LoggedInViewController.swift
//  NestLogin
//
//  Created by Michael Dautermann on 11/20/15.
//  Copyright © 2015 Michael Dautermann. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    var accessTokenText : String = ""
    
    @IBOutlet var textView : UITextView!
    
    func getAuthorizationToken() -> String {
    
        let ud  = NSUserDefaults()

        let expirationDate = ud.objectForKey("expiration_date") as! NSDate
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        let defaultTimeZoneStr = formatter.stringFromDate(expirationDate);
        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
        formatter.timeZone = NSTimeZone.localTimeZone()
        let utcTimeZoneStr = formatter.stringFromDate(expirationDate);
        
        print("\(utcTimeZoneStr)")

        return ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = accessTokenText
        
        getAuthorizationToken()
        
        print("\(accessTokenText)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
