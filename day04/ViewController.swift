//
//  ViewController.swift
//  Day04
//
//  Created by Simon GAUDIN on 1/12/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

let CONSUMER_KEY = "QFurqUHqHsFQZBil0gLiTkEfq"
let CONSUMER_SECRET = "BDkurZXwiCT25vES6LzV8noMY8d8YFNEvFPUCBGOSyOY2ueYzE"
let BEARER = (CONSUMER_KEY + ":" + CONSUMER_SECRET).data(using: String.Encoding.utf8)
let ENCODED_BEARER = BEARER?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

class ViewController: UIViewController {

    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getToken()
//        print("token : \(self.token!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getToken()
    {
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        var tokayn:String = ""
        request.httpMethod = "POST"
        request.setValue("Basic " + ENCODED_BEARER!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error { print(err) }
            else if let d = data
            {
                do
                {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    {
                        tokayn = (dic["access_token"]! as? String)!
                        print("tokayn2n = \(tokayn)")
                    }
                }
                catch (let err) { print(err) }
            }
        }
        
        task.resume()
        print("tokayn = \(tokayn)")
    }
    
}
