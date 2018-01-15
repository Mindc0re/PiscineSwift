//
//  EditTopicViewController.swift
//  Forum
//
//  Created by Jordan MUNOZ on 1/14/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

class EditMessageViewController: UIViewController, UITextViewDelegate {
    
    var delegate: MessagesProtocol?
    var message: Message?
    var isReplies: Bool?
    var refTopic: Topic?
    var refMessage: Message?

    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = tv.font?.withSize(16)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 30/255, green: 186/255, blue: 187/100, alpha: 1)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleButtonTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTextView.delegate = self
        self.navigationItem.title = "Message Edition"
        self.view.backgroundColor = .white
        self.setupViews()
        
        if self.message != nil {
            self.contentTextView.text = self.message?.content
            button.setTitle("Modify", for: .normal)
        }
    }
    
    @objc func handleButtonTouched() {
        // update
        if (self.contentTextView.text == "") {
            print ("Enter a content")
            return 
        }
        if ((self.message) != nil) {
            self.message?.content = self.contentTextView.text
            httpRequest.putMessage(message: self.message!, callback: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    if (self.isReplies!) {
                        self.delegate?.fetchReplies()
                    } else {
                        self.delegate?.fetchMessages()
                    }
                }
            })
        } else {
            self.message = Message(content: self.contentTextView.text)
            let id = (self.isReplies == true) ? self.refMessage?.id : self.refTopic?.id
            let type = (self.isReplies == true) ? "message" : "topic"
            httpRequest.postMessage(message: MessageWrap(message: self.message!), id: "\(id!)", type: type, callback: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    if (self.isReplies!) {
                        self.delegate?.fetchReplies()
                    } else {
                        self.delegate?.fetchMessages()
                    }
                }
            })
        }
    }
    
    func setupViews() {
            self.view.addSubview(button)
        
        self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            self.view.addSubview(contentTextView)
            
            self.contentTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.contentTextView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
            self.contentTextView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            self.contentTextView.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -20).isActive = true
        

    }
}

