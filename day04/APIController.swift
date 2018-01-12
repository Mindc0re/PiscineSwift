//
//  APIController.swift
//  Day04
//
//  Created by Simon GAUDIN on 1/12/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class
{
    func handleTweets(t: Tweet)
    func handleError(err: NSError)
}

class APIController
{
    weak var delegate: APITwitterDelegate?
    
    let token : String
    
    init(del: APITwitterDelegate?, tok: String)
    {
        self.delegate = del
        self.token = tok
    }
    
}
