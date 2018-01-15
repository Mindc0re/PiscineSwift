//
//  ViewController.swift
//  Forum
//
//  Created by Anil KARAGOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

protocol TopicsProtocol {
    func fetchTopics(completion: @escaping () -> Void)
    func refreshTopics()
}

class TopicsViewController: UITableViewController, TopicsProtocol {
    let topicCellId = "TopicCell"
    var topics: [Topic] = []
    var isLoading: Bool = false
    var didReachEnd: Bool = false
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Topics"
        
        // Navigation
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = logoutButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleCreation))
        self.navigationItem.rightBarButtonItem = editButton
        
        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
        
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTopics), for: .valueChanged)
        // Make cell autosizable
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(TopicCell.self, forCellReuseIdentifier: self.topicCellId)

        // Set the separator to 1 line
        self.tableView.tableFooterView = UIView()
        
        checkIfUserLogged()
    }
    
    func checkIfUserLogged() {
        if (httpRequest.accessToken == nil) {
            self.handleLogout()
        } else {
            fetchTopics(completion: {})
        }
    }
    
    @objc func refreshTopics() {
        self.page = 1
        self.didReachEnd = false
        self.tableView.refreshControl?.beginRefreshing()
        fetchTopics {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func nextPage() {
        self.page += 1
        self.tableView?.refreshControl?.beginRefreshing()
        httpRequest.getAllTopics(page: self.page, callback: { (topics) in
            self.topics += topics
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                self.isLoading = false
            }
        })
    }
    
    func fetchTopics(completion: @escaping () -> Void) {
        httpRequest.getAllTopics(callback: { (topics) in
            if (topics.isEmpty) {
                self.didReachEnd = true
            }
            self.topics = topics
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                completion()
            }
        })
    }
    
    func deleteCookies() {
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    func handleEdit(topic: Topic) {
        let controller = EditTopicViewController()
        controller.delegate = self
        controller.topic = topic

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleCreation() {
        let controller = EditTopicViewController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogout() {
        // TMP we should delete the token from the local storage
        httpRequest.accessToken = nil
        self.deleteCookies()
        let controller = LoginViewController()
        controller.delegate = self
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if (self.topics.count > 0 && self.isLoading == false && self.didReachEnd == false && httpRequest.accessToken != nil) {
                self.isLoading = true
                self.nextPage()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topics.count
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = self.topics[indexPath.row]
        return (cell.author?.id! == httpRequest.userId!)
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let topic = self.topics[indexPath.row]
        
        let modifyAction = UIContextualAction(style: .normal, title:  "Modify", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.handleEdit(topic: topic)
            success(true)
        })
        modifyAction.backgroundColor = .green
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Delete ?", message: "Are you sure you want to delete '\(topic.name!)'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                httpRequest.deleteTopic(topic: topic, callback: {
                    DispatchQueue.main.async {
                        self.refreshTopics()
                    }
                })
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = self.topics[indexPath.row]
        let controller = MessagesViewController()
        controller.topic = topic
        controller.navTitle = "Messages"
        self.navigationController?.pushViewController(controller, animated: true)
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
