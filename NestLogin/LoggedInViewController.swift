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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = accessTokenText
    }
    
}
