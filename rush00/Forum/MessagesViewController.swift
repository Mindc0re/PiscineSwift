//
//  ViewController.swift
//  Forum
//
//  Created by Anil KARAGOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

protocol MessagesProtocol {
    func fetchReplies()
    func fetchMessages()

}

class MessagesViewController: UITableViewController, MessagesProtocol {
    let messageCellId = "messageCell"
    var topic: Topic?
    var messages: [Message] = []
    var refMessage: Message?
    var navTitle: String?
    var isLoading: Bool = false
    var didReachEnd: Bool = false
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = navTitle!
        
        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl

        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleCreation))
        self.navigationItem.rightBarButtonItem = editButton
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        // Make cell autosizable
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: self.messageCellId)
        
        // Set the separator to 1 line
        self.tableView.tableFooterView = UIView()
        if (navTitle! ==  "Messages") {
            fetchMessages()
        } else if (navTitle! == "Replies") {
            fetchReplies()
        }
            
    }
    
    @objc func fetchMessages() {
        self.tableView.refreshControl?.beginRefreshing()
        httpRequest.getAllMessagesByTopic(topic: self.topic!, page: self.page, callback: { (messages) in
            print(messages)
            if (messages.isEmpty) {
                DispatchQueue.main.async {
                    self.didReachEnd = true
                    self.tableView.refreshControl?.endRefreshing()
                    self.isLoading = false
                    return
                }
            }
            self.messages += messages
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.isLoading = false
            }
        })
    }
    
    
    @objc func handleCreation() {
        let controller = EditMessageViewController()
        controller.delegate = self
        
        if (self.navTitle == "Replies") {
            controller.refMessage = self.refMessage
            controller.isReplies = true
        } else {
            controller.refTopic = self.topic
            controller.isReplies = false
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleEdit(message: Message) {
        let controller = EditMessageViewController()
        controller.delegate = self
        controller.message = message
        if (self.navTitle == "Replies") {
            controller.refMessage = self.refMessage
            controller.isReplies = true
        } else {
            controller.refTopic = self.topic
            controller.isReplies = false
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refresh() {
        self.didReachEnd = false
        self.page = 1
        self.messages = []
        self.tableView.reloadData()
        if (navTitle! ==  "Messages") {
            fetchMessages()
        } else if (navTitle! == "Replies") {
            fetchReplies()
        }
    }
    
    func nextPage() {
        self.page += 1
        if (navTitle! ==  "Messages") {
            fetchMessages()
        } else if (navTitle! == "Replies") {
            fetchReplies()
        }
    }
    
    @objc func fetchReplies() {
        self.tableView.refreshControl?.beginRefreshing()
        httpRequest.getAllMessagesByMessage(message: self.refMessage!, page: self.page) { (messages) in
            if (messages.isEmpty) {
                self.didReachEnd = true
            }
            self.messages += messages
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if (self.messages.count > 0 && self.isLoading == false && self.didReachEnd == false) {
                self.isLoading = true
                self.nextPage()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.navTitle == "Replies") {
            return
        }
        let message = self.messages[indexPath.row];
        let controller = MessagesViewController()
        controller.navTitle = "Replies"
        controller.refMessage = message
        controller.topic = self.topic
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.messages.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.tableView.bounds.size.width,
                          height: self.tableView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = "No messages ! :("
        noDataLabel.textColor = .black
        noDataLabel.textAlignment = .center
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = self.messages[indexPath.row]
        return (cell.author?.id! == httpRequest.userId!)
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let message = self.messages[indexPath.row]
        
        let modifyAction = UIContextualAction(style: .normal, title:  "Modify", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.handleEdit(message: message)
            success(true)
        })
        modifyAction.backgroundColor = .green
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Delete ?", message: "Are you sure you want to delete this message ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                httpRequest.deleteMessage(message: message, callback: {
                    DispatchQueue.main.async {
                        if (self.navTitle == "Messages") {
                            self.fetchMessages()
                        } else if (self.navTitle == "Replies") {
                            self.fetchReplies()
                        }
                        
                    }
                })
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        deleteAction.backgroundColor = .red
        var acts = [modifyAction]
        
        if ((indexPath.row != 0 && self.navTitle == "Messages") || (navTitle == "Replies")) {
            acts.append(deleteAction)
        }
        return UISwipeActionsConfiguration(actions: acts)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.messageCellId, for: indexPath) as! MessageCell
        let message = self.messages[indexPath.row]
        cell.authorLabel.text = "From " + (message.author?.login)!
        cell.contentLabel.text = message.content!
        cell.dateLabel.text = message.created_at!
        if (message.replies!.count > 0) {
            cell.repliesLabel.text = "\(message.replies!.count) replies"
        } else {
            cell.repliesLabel.text = ""
        }
        return cell
    }
    
}

class MessageCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentLabel: UILabel = {
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
    
    let repliesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func setupViews() {
       
        self.addSubview(authorLabel)
        // authorLabel constraints
        self.authorLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        self.authorLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.authorLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        
        self.addSubview(dateLabel)
        // dateLabel constraint
        self.dateLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        
        self.addSubview(contentLabel)
        // contentLabel constraints
        self.contentLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor).isActive = true
        self.contentLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.contentLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        self.addSubview(repliesLabel)
        
        self.repliesLabel.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor).isActive = true
        self.repliesLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.repliesLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.repliesLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        
    }
}

