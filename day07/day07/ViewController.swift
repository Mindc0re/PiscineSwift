//
//  ViewController.swift
//  day07
//
//  Created by Simon GAUDIN on 1/17/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    var botRecast: RecastAIClient?
    var darkSkyClient: DarkSkyClient?
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var requestTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        botRecast = RecastAIClient(token: "e2ed40bafbce78616176ab979bca591e", language: "en")
        darkSkyClient = DarkSkyClient(apiKey: "40584a8a9de75a0a0e41304e2ca579a2")
        darkSkyClient?.units = .auto
        darkSkyClient?.language = .english
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func requestSucceeded(response: Response) -> Void
    {
        if let loc = (response.get(entity: "location"))
        {
            print("Latitude : \(loc["lat"]!)")
            print("Longitude : \(loc["lng"]!)")
            
            darkSkyClient?.getForecast(latitude: loc["lat"] as! Double, longitude: loc["lng"] as! Double, completion:
            { (result) in
                switch result
                {
                case .success(let currentForecast, _):
                    DispatchQueue.main.async {
                        self.responseLabel.text = currentForecast.currently?.summary
                    }
                        break
                    case .failure(let error):
                        print(error)
                        break
                }
            })
        }
        else
        {
            responseLabel.text = "Error"
        }
    }
    
    func requestFailed(error: Error) -> Void
    {
        responseLabel.text = "Error"
    }

    @IBAction func makeRequest(_ sender: UIButton)
    {
        if let requestStr = requestTextField.text
        {
            botRecast?.textRequest(requestStr, successHandler: requestSucceeded, failureHandle: requestFailed)
        }
    }
}

