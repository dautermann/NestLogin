//
//  AuthorizationViewController.swift
//  NestLogin
//
//  Created by Michael Dautermann on 11/20/15.
//  Copyright © 2015 Michael Dautermann. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView : UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let requestURL = NSURL.init(string: "https://home.nest.com/login/oauth2?client_id=27415fff-3db9-44e5-bef8-49d1f9c60bbe&state=DoingANestDemo") {
            let request = NSURLRequest.init(URL: requestURL, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
            webView.loadRequest(request)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func saveAccessToken(withAuthCode : String?)
    {
        if let authCode = withAuthCode as String! {
            let url = NSURL(string: "https://api.home.nest.com/oauth2/access_token?client_id=27415fff-3db9-44e5-bef8-49d1f9c60bbe&code=\(authCode)&client_secret=DHNnft0K8OYtqfVXd3TVYU27J&grant_type=authorization_code")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if let error = error {
                    print("error while logging in \(error.localizedDescription)")
                } else {
                    var statusCode : Int = 200 // start off with OK
                    
                    if let httpResponse = response as? NSHTTPURLResponse {
                        statusCode = httpResponse.statusCode
                    }
                    
                    if(statusCode == 200) {
                        let stringFromData = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
                        
                        do {
                            let parsedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                            guard let accessTokenDict = parsedJson as? NSDictionary else {
                                print("Not a Dictionary")
                                // put in function
                                return
                            }

                            let expiresInSeconds = accessTokenDict["expires_in"] as! Double
                            
                            let expirationDate = NSDate().dateByAddingTimeInterval(expiresInSeconds)
                            
                            NSUserDefaults.standardUserDefaults().setObject(expirationDate, forKey: "expiration_date")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loggedInVC = storyboard.instantiateViewControllerWithIdentifier("LoggedInViewController") as! LoggedInViewController
                            loggedInVC.accessTokenText = stringFromData
                            
                            // need to do UI things on the main queue
                            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                                self.navigationController?.pushViewController(loggedInVC, animated: true)
                            }
                            
                            
                        } catch let jsonError as NSError {
                            print("\(jsonError)")
                        }
                    } else {
                        print("Error could not login \(statusCode)")
                    }
                }
            })
            task.resume()
        }
    }
    
    func getAuthCode(fromURL : NSURL)
    {
        if let urlComponents = NSURLComponents.init(URL: fromURL, resolvingAgainstBaseURL: true)
        {
            if let queryItems = urlComponents.queryItems {
                for item in queryItems {
                    if item.name == "code" {
                        saveAccessToken(item.value)
                    }
                }
            }
        } else {
            print("didn't get any url components")
        }
    }
    
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool{
        if let request = webView.request {
            if let requestURL = request.URL {
                if requestURL.host == "mail.deathstar.org" {
                    getAuthCode(requestURL)
                }
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("finished loading \(webView.request!.URL!.absoluteString)")
        
        if let request = webView.request {
            if let requestURL = request.URL {
                if requestURL.host == "mail.deathstar.org" {
                    getAuthCode(requestURL)
                }
            }
        }
    }

    func webView(webView: UIWebView,
        didFailLoadWithError error: NSError?) {
            print("failed loading \(webView.request!.URL!.absoluteString) with error \(error!.localizedDescription)")
    }
}
