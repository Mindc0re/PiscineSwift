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
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue)
    {
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let sylFormat = DateFormatter();
        sylFormat.dateFormat = "dd/MM/yyyy HH:mm:ss";
        let sylDate = sylFormat.date(from: "06/06/2066 06:06:06");

        let jackFormat = DateFormatter();
        jackFormat.dateFormat = "dd/MM/yyyy HH:mm:ss";
        let jackDate = jackFormat.date(from: "05/07/2019 14:12:00");
        
        let loganFormat = DateFormatter();
        loganFormat.dateFormat = "dd/MM/yyyy HH:mm:ss";
        let loganDate = loganFormat.date(from: "16/02/2018 16:12:57");
        
        Data.people =
        [
            ("Sylvain Durif" , sylDate!, "Mort d'overdose"),
            ("Jacques Chirac", jackDate!, "Mort de sénilité"),
            ("Logan Paul", loganDate!, "Pendu dans la foret d'Aokigahara")
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.people.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pCell") as! PeopleTableViewCell
        cell.person = Data.people[indexPath.section]
        
        return cell
    }

}

