//
//  ViewController.swift
//  Day02
//
//  Created by Simon GAUDIN on 1/10/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    {
        didSet
        {
            tableView.delegate = self
            tableView.dataSource = self 
        }
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pCell") as! PeopleTableViewCell
        cell.person = Data.people[indexPath.row]
        
        return cell
    }

}

