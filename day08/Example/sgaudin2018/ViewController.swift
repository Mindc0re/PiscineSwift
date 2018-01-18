//
//  ViewController.swift
//  sgaudin2018
//
//  Created by mindc0re on 01/18/2018.
//  Copyright (c) 2018 mindc0re. All rights reserved.
//

import UIKit
import sgaudin2018

class ViewController: UIViewController {

    var manager: ArticleManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = ArticleManager(completionClosure: {
            DispatchQueue.main.async {
                self.letsGo()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func letsGo()
    {
        if let article = manager?.newArticle()
        {
            article.titre = "HELLO WORLD MO'FO"
            article.content = "WE HERE"
            article.image = nil
            article.dateCreate = NSDate()
            article.dateModif = NSDate()
            print("\(article)\n")
            do
            {
                try self.manager?.managedObjectContext.save()
            }
            catch { print("couldnt save...") }
            manager?.getAllArticles()
        }
    }
    
}

