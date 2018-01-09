//
//  ViewController.swift
//  Day00Ex01
//
//  Created by Simon GAUDIN on 1/8/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeLabelText(_ sender: UIButton)
    {
        myLabel.text = "Bonjour monde !";
    }
    
}

