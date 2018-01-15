//
//  LoginViewController.swift
//  Forum
//
//  Created by Anil KARAGOZ on 1/13/18.
//  Copyright © 2018 Anil KARAGOZ. All rights reserved.
//

import UIKit

protocol LoginProtocol {
    func didLogin()
}

class LoginViewController: UIViewController, LoginProtocol {
    
    var delegate: TopicsProtocol?
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 30/255, green: 186/255, blue: 187/100, alpha: 1)
        button.setTitle("Connect to 42", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "42logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 42/255, green: 46/255, blue: 57/255, alpha: 1)
        self.setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(logoImageView)
        // loginImageView constraints
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -20).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        self.view.addSubview(loginButton)
        // loginButton constraints
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: 20).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.loginButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    @objc func handleLogin() {
        let controller = IntraWebViewController()
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    func didLogin() {
        self.delegate?.fetchTopics(completion: {})
        self.dismiss(animated: true, completion: nil)
    }
}
