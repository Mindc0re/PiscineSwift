//
//  ViewController.swift
//  Day00Ex02
//
//  Created by Simon GAUDIN on 1/8/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calculLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func printDebug(_ sender: UIButton)
    {
        let keyName = (sender.titleLabel?.text)!;
        
        print("[DEBUG] '\(keyName)' key pressed");
        switch keyName {
        case "AC":
            print("Clearing calculation\n");
            break ;
        case "NEG":
            print("Converting the number to its opposite\n");
            break ;
        case "+":
            print("Proceeding to the 'Addition' mode\n");
            break ;
        case "-":
            print("Proceeding to the 'Substraction' mode\n");
            break ;
        case "*":
            print("Proceeding to the 'Multiplication' mode\n");
            break ;
        case "/":
            print("Proceeding to the 'Division' mode\n");
            break ;
        case "/":
            print("Proceeding to the calculation\n");
            break ;
        default:
            print("Adding the digit to the calculation\n");
            break ;
        }
    }
    
    @IBAction func AddDigit(_ sender: UIButton)
    {
        var newText: String;
        
        newText = calculLabel.text! + (sender.titleLabel?.text)!;
        calculLabel.text = newText;
    }
    
}

