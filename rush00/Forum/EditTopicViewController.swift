//
//  EditTopicViewController.swift
//  Forum
//
//  Created by Jordan MUNOZ on 1/14/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

class EditTopicViewController: UIViewController, UITextViewDelegate {
    
    var delegate: TopicsProtocol?
    var topic: Topic?
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Topic name", attributes: [NSAttributedStringKey.paragraphStyle: centeredParagraphStyle])
        tf.attributedPlaceholder = attributedPlaceholder
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        return tf
    }()
    
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
        self.navigationItem.title = "Topic Edition"
        self.view.backgroundColor = .white
        self.setupViews()
        
        if self.topic != nil {
            self.nameTextField.text = self.topic?.name
            self.nameTextField.textColor = .black
            self.contentTextView.text = self.topic?.message?.content?.markdown
            button.setTitle("Modify", for: .normal)
        }
    }
    
    @objc func handleButtonTouched() {
        // update
        if (self.nameTextField.text! == "" || self.contentTextView.text! == "") {
            print("Please enter a name and a text")
            return
        }
        if ((self.topic) != nil) {
            self.topic?.message = nil
            self.topic?.name = self.nameTextField.text
            self.topic?.cursus_ids = nil
            httpRequest.putTopic(topic: self.topic!, callback: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                        self.delegate?.refreshTopics()
                }
            })
        } else {
            let messageAttributes = Messages_Attributes(content: self.contentTextView.text)
            self.topic = Topic(kind: "normal", language_id: "1", name: self.nameTextField.text, messages_attributes: [messageAttributes], tag_ids: ["578"], cursus_ids: ["1"])
            httpRequest.postTopic(topic: TopicWrap(topic: self.topic!), callback: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.refreshTopics()
                }
            })
            print("Create topic")
        }
        print("Button touched")
    }
    
    func setupViews() {
        self.view.addSubview(nameTextField)
        
        self.nameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.nameTextField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.nameTextField.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(button)
        if (self.topic == nil) {

            self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            self.view.addSubview(contentTextView)
            
            self.contentTextView.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20).isActive = true
            self.contentTextView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
            self.contentTextView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            self.contentTextView.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -20).isActive = true
        } else {
            self.button.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 20).isActive = true
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }
}
