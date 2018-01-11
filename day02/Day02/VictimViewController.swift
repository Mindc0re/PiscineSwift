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
        descTextView.layer.cornerRadius = 8;
        
        datePicker.layer.cornerRadius = 8;
        datePicker.backgroundColor = UIColor.white;
        
        nameTextField.layer.cornerRadius = 8;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateMinDate()
    {
        let date = Date();
        let calendar = Calendar.current;
        let minComp = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date);
        
        let minDate = calendar.date(from: minComp);
        datePicker.minimumDate = minDate!;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue"
        {
            updateMinDate()
            if let _ = nameTextField.text
            {
                if (nameTextField.text?.isEmpty)! == false
                {
                    if descTextView.text.isEmpty == true { Data.people.append((nameTextField.text!, datePicker.date, "")); }
                    else { Data.people.append((nameTextField.text!, datePicker.date, descTextView.text!)); }
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                print("Name of the victim : \(nameTextField.text!)");
                print("Death date : \(formatter.string(from: datePicker.date))");
                print("Death description : \(descTextView.text!)");
            }
        }
    }

    @IBAction func updateMinimumDate(_ sender: UIDatePicker)
    {
        updateMinDate()
    }
    
}
