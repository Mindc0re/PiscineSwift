//
//  ViewController.swift
//  sgaudin2018
//
//  Created by mindc0re on 01/18/2018.
//  Copyright (c) 2018 mindc0re. All rights reserved.
//

import UIKit
import CoreData
import sgaudin2018

class ViewController: UIViewController {

    var manager: ArticleManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = ArticleManager(completionClosure: {
            DispatchQueue.main.async {
                self.launchDemo()
            }
        })
        
        self.manager = ArticleManager(completionClosure: {
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func launchDemo()
    {

        guard let article1 = manager?.newArticle() else { print("ERROR : COULD NOT CREATE ARTICLE\n"); return }
        article1.titre = "Bonjour monde 1"
        article1.content = "Je suis heureux de creer cet article"
        article1.langue = "fr"
        article1.image = nil
        article1.dateCreate = NSDate()
        article1.dateModif = NSDate()
        
        
        guard let article2 = manager?.newArticle() else { print("ERROR : COULD NOT CREATE ARTICLE\n"); return }
        article2.titre = "Bonjour monde 2"
        article2.content = "Je suis vraiment heureux de creer cet article"
        article2.langue = "fr"
        article2.image = nil
        article2.dateCreate = NSDate()
        article2.dateModif = NSDate()
        
        
        guard let article3 = manager?.newArticle() else { print("ERROR : COULD NOT CREATE ARTICLE\n"); return }
        article3.titre = "HELLOOOOOOZ"
        article3.content = "I am really happy to create this article"
        article3.langue = "en"
        article3.image = nil
        article3.dateCreate = NSDate()
        article3.dateModif = NSDate()
        
        print("Created 3 articles :\n\(article1.description)\n\(article2.description)\n\(article3.description)")
        
        self.manager?.save()

        let allArticles = self.manager?.getAllArticles()
        print("Here are all the articles stored : \n\n\(allArticles!)")
        
    }
    
}

