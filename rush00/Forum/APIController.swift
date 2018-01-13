//
//  APIController.swift
//  Forum
//
//  Created by Simon GAUDIN on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import Foundation

let UID = "ab334005d7b24e26e789aac1f00485c96d9e71ed260ad41f7e1c3c41e15b5c09"
let SECRET = "32f88c0bf2b4fd8326c577853e340e18d4ba407994f7d994aeeb0d9d82d2bb7b"
let BEARER = (UID + ":" + SECRET).data(using: String.Encoding.utf8)
let ENCODED_BEARER = BEARER?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

class APIController
{
    
    var accessToken: String?
    
    func createAuthRequest() -> URLRequest
    {
        let urlAuth = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=ab334005d7b24e26e789aac1f00485c96d9e71ed260ad41f7e1c3c41e15b5c09&redirect_uri=https%3A%2F%2Fforum.intra.42.fr%2F&response_type=code&scope=public+forum")
        var request = URLRequest(url: urlAuth!)
        
        request.httpMethod = "GET"
        request.setValue("Basic " + ENCODED_BEARER!, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        return request
    }
    
    func getAccessTokenWithCode(code: String, completionHandler: @escaping (Error?) -> Void)
    {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url!)
        let redirect_uri = "https://forum.intra.42.fr/"
        
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(SECRET)&code=\(code)&redirect_uri=\(redirect_uri)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("\ngetAccesToken error : \(err)\n")
                completionHandler(err)
            }
            else if let d = data
            {
                do
                {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    {
                        print("\nReceived dic :\n\(dic)\n\n")
                        self.accessToken = dic["access_token"] as? String
                        completionHandler(nil)
                    }
                }
                catch(let err) {
                    print(err)
                    completionHandler(err)
                }
            }
        }
        
        task.resume()
    }
    
    func getAllTopics(completionHandler: @escaping ([Topic]?) -> Void)
    {
        let url = URL(string: "https://api.intra.42.fr/v2/topics.json")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error in getAllTopics :\n\(err)")
                completionHandler(nil)
            }
            else if let d = data
            {
                do
                {
                    let topics = try JSONDecoder().decode([Topic].self, from: d)
                    completionHandler(topics)
                }
                catch(let err)
                {
                    print(err);
                    completionHandler(nil)
                }
            }
        }
        
        task.resume()
    }
    
//    func postTopic()
//    {
//        let url = URL(string: "https://api.intra.42.fr/v2/topics.json")
//        var request = URLRequest(url: url!)
//
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//
//    }

}
