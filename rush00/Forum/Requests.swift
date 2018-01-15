//
//  Requests.swift
//  Forum
//
//  Created by Jordan MUNOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import Foundation

class HttpRequest {
    var URL_BASE: String = "https://api.intra.42.fr"
    var request: URLRequest?
    
    var accessToken: String?
    var userId: Int?
    
    func createAuthRequest() -> URLRequest
    {
        let urlAuth = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=ab334005d7b24e26e789aac1f00485c96d9e71ed260ad41f7e1c3c41e15b5c09&redirect_uri=https%3A%2F%2Fforum.intra.42.fr%2F&response_type=code&scope=public+forum")
        var request = URLRequest(url: urlAuth!)
        
        request.httpMethod = "GET"
        request.setValue("Basic " + ENCODED_BEARER!, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        return request
    }
    
    func getUserId()
    {
        let url = URL(string: "https://api.intra.42.fr/v2/me")
        var request = URLRequest(url: url!)
        
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                }
            }
            //Data can be read
            if let d = data {
                do
                {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    {
                        self.userId = dic["id"] as? Int
                        print("\n\nUser ID : \(self.userId!)\n")
                    }
                }
                catch(let err) { print(err) }
            }
        }.resume()
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
                        self.getUserId()
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
    
    func getAllTopics(page: Int? = 1, callback : @escaping ([Topic]) -> Void) {
        
        let endpoint = "/v2/topics.json?filter[language_id]=1&sort=-updated_at&page[number]=\(page!)";
        
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                }
            }

            //Data can be read
            if let d = data {
                var decoded: [Topic];
                do {
                    decoded = try JSONDecoder().decode([Topic].self, from: d);
                } catch(let e) {
                    print("decodeFromJSON Error: \(e)");
                    return
                }
                callback(decoded)
            }
        }.resume()
    }
    
    func getAllMessagesByTopic(topic: Topic, page: Int? = 1, callback : @escaping ([Message]) -> Void) {
        
        let endpoint: String;
        if let topic_id = topic.id {
            endpoint = "/v2/topics/\(topic_id)/messages.json?page[number]=\(page!)"
        } else {
            endpoint = "/v2/messages.json?page[number]=\(page!)"
        }

        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                }
            }
            //Data can be read
            if let d = data {
                var decoded: [Message];
                do {
                    decoded = try JSONDecoder().decode([Message].self, from: d)
                    callback(decoded)
                } catch(let e) {
                    print("decodeFromJSON Error: \(e)")
                    return
                }
            }
        }
        task.resume();
    }
    
    func getAllMessagesByMessage(message: Message, page: Int? = 1, callback : @escaping ([Message]) -> Void) {
        
        let endpoint: String;
        if let message_id = message.id {
            endpoint = "/v2/messages/\(message_id)/messages.json?page[number]=\(page!)";
        } else {
            endpoint = "/v2/messages.json?page[number]=\(page!)";
        };
        
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                }
            }
            //Data can be read
            if let d = data {
                var decoded: [Message];
                do {
                    decoded = try JSONDecoder().decode([Message].self, from: d);
                    callback(decoded)
                } catch(let e) {
                    print("decodeFromJSON Error: \(e)");
                    return
                }
            }
        }
        task.resume();
    }
    
    func postTopic(topic: TopicWrap, callback: @escaping () -> Void) {
        
        let endpoint = "/v2/topics.json";
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        do {
            request.httpBody = try JSONEncoder().encode(topic)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //Error has been thrown
                if let err = error {
                    print("Request Error: \(err)")
                    return
                }
                //Response code is invalid
                if let r = response {
                    let h = r as! HTTPURLResponse
                    if h.statusCode < 200 || h.statusCode >= 300 {
                        print("Status code is \(h.statusCode)")
                        return
                    } else {
                        callback();
                    }
                }
            }
            task.resume();
        } catch {
            print("Encoding of topic: \(topic) failed")
            return
        }
    }
    
    func postMessage(message: MessageWrap, id: String, type: String, callback: @escaping () -> Void) {
        
        var endpoint = "";
        if (type == "topic") {
            endpoint = "/v2/topics/\(id)/messages"
        } else {
            endpoint = "/v2/messages/\(id)/messages"
        }
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(message)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //Error has been thrown
                if let err = error {
                    print("Request Error: \(err)")
                    return
                }
                //Response code is invalid
                if let r = response {
                    let h = r as! HTTPURLResponse
                    if h.statusCode < 200 || h.statusCode >= 300 {
                        print("Status code is \(h.statusCode)")
                        return
                    } else {
                        callback();
                    }
                }
            }
            task.resume();
        } catch {
            print("Encoding of topic: \(message) failed")
            return
        }
    }
    
    func putTopic(topic: Topic, callback: @escaping () -> Void) {
        
        guard let topicId = topic.id?.description else { return }
        let endpoint = "/v2/topics/\(topicId)";
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            
            request.httpBody = try JSONEncoder().encode(topic)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //Error has been thrown
                if let err = error {
                    print("Request Error: \(err)")
                    return
                }
                //Response code is invalid
                if let r = response {
                    let h = r as! HTTPURLResponse
                    if h.statusCode < 200 || h.statusCode >= 300 {
                        print("Status code is \(h.statusCode)")
                        return
                    } else {
                        callback();
                    }
                }
            }
            task.resume();
        } catch {
            print("Encoding of topic: \(topic) failed")
            return
        }
    }
    
    func putMessage(message: Message, callback: @escaping () -> Void) {
        
        guard let messageId = message.id?.description else { return }
        let endpoint = "/v2/messages/\(messageId)";
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(message)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //Error has been thrown
                if let err = error {
                    print("Request Error: \(err)")
                    return
                }
                //Response code is invalid
                if let r = response {
                    let h = r as! HTTPURLResponse
                    if h.statusCode < 200 || h.statusCode >= 300 {
                        print("Status code is \(h.statusCode)")
                        return
                    } else {
                        callback();
                    }
                }
            }
            task.resume();
        } catch {
            print("Encoding of topic: \(message) failed")
            return
        }
    }
    
    func deleteTopic(topic: Topic, callback: @escaping () -> Void) {
        
        guard let topicId = topic.id?.description else { return }
        let endpoint = "/v2/topics/\(topicId).json";
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                } else {
                    callback();
                }
            }
        }
        task.resume();
    }
    
    func deleteMessage(message: Message, callback: @escaping () -> Void) {
        guard let messageId = message.id?.description else { return }
        let endpoint = "/v2/messages/\(messageId).json";
        guard let url = URL(string: URL_BASE + endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE";
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Error has been thrown
            if let err = error {
                print("Request Error: \(err)")
                return
            }
            //Response code is invalid
            if let r = response {
                let h = r as! HTTPURLResponse
                if h.statusCode < 200 || h.statusCode >= 300 {
                    print("Status code is \(h.statusCode)")
                    return
                } else {
                    callback();
                }
            }
        }
        task.resume();
    }
}
