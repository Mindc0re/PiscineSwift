//
//  VictimViewController.swift
//  Day02
//
//  Created by Simon GAUDIN on 1/10/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class VictimViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        descTextView.layer.borderWidth = 1.0;
        descTextView.layer.borderColor = UIColor.black.cgColor;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButton(_ sender: Any)
    {
        performSegue(withIdentifier: "doneSegue", sender: "Done");
    }
    
    @IBAction func updateMinimumDate(_ sender: UIDatePicker)
    {
        let date = Date();
        let calendar = Calendar.current;
        let minComp = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date);
        
        let minDate = calendar.date(from: minComp);
        datePicker.minimumDate = minDate!;
    }
    
}
