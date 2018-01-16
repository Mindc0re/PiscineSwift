//
//  SecondViewController.swift
//  day05
//
//  Created by Simon GAUDIN on 1/15/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let addressesTab = ["42", "Home Clichy", "Home Tarbes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressesTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell")
        cell?.textLabel?.text = addressesTab[indexPath.row]
        cell?.isUserInteractionEnabled = true
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMap"
        {
            let cell = sender as! UITableViewCell
            if let cellText: String = cell.textLabel?.text
            {
                let mapVC = segue.destination as! MapViewController
                switch cellText
                {
                    case "42":
                        mapVC.placeChoice = Chosen_Place.Ecole42
                        break
                    case "Home Clichy":
                        mapVC.placeChoice = Chosen_Place.ChezMoiClichy
                        break
                    case "Home Tarbes":
                        mapVC.placeChoice = Chosen_Place.ChezMoiTarbes
                        break
                    default:
                        break
                }
            }
        }
    }
    
}

