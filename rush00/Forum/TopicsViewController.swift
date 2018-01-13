//
//  ViewController.swift
//  Forum
//
//  Created by Anil KARAGOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

class TopicsViewController: UITableViewController {
    let topicCellId = "TopicCell"
    var topics: [Topic] = [
        Topic(name: "SCANDALEUX !", author: Author(login: "wdestin"), date: "Hier"),
        Topic(name: "Mon ordinateur est cassé!", author: Author(login:"uozdemir"), date: "Il y a quatre jours"),
        Topic(name: "Je suis trop beau, parlons-en", author: Author(login: "akaragoz"), date: "Il y a deux jours"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Topics"
        
        // Navigation
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = logoutButton
        
        // Make cell autosizable
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(TopicCell.self, forCellReuseIdentifier: self.topicCellId)

        // Set the separator to 1 line
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func handleLogout() {
        let controller = LoginViewController()
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.topicCellId, for: indexPath) as! TopicCell
        let topic = self.topics[indexPath.row]
        cell.titleLabel.text = topic.name!
        cell.authorLabel.text = "From " + (topic.author?.login)!
        cell.dateLabel.text = topic.date!

        return cell
    }
    
}

class TopicCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func setupViews() {
        self.addSubview(titleLabel)
        // titleLabel constraints
        self.titleLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true

        self.addSubview(authorLabel)
        // authorLabel constraints
        self.authorLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.authorLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.authorLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        self.authorLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.addSubview(dateLabel)
        // dateLabel constraint
        self.dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.dateLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
    }
}
