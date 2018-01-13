//
//  ViewController.swift
//  rush00
//
//  Created by Simon GAUDIN on 1/13/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import Foundation

class IntraWebViewController: UIViewController, UIWebViewDelegate {
    var delegate: LoginProtocol?
    let webView: UIWebView = {
        let wv = UIWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    func setupViews()
    {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.webView.delegate = self
        webView.loadRequest(apiController.createAuthRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let urlString = request.url?.absoluteString
        
        if (urlString?.contains("https://forum.intra.42.fr/"))!
        {
            let queryItems = URLComponents(string: urlString!)?.queryItems
    
            for item in queryItems!
            {
                if (item.name == "code")
                {
                    if let code = item.value
                    {
                        print("\n\ncode = \(code)\n\n")
                        
                        apiController.getAccessTokenWithCode(code: code, completionHandler: { (error) in
                            if let err = error { print(err) }
                            else
                            {
                                self.dismiss(animated: true, completion: nil)
                                self.delegate?.didLogin()
                                print("\n\napiController.acessToken = \(apiController.accessToken!)\n")
                            }
                        })
                    }
                }
            }
        }
        
        return true
    }
    
    
}

