//
//  PeopleTableViewCell.swift
//  Day02
//
//  Created by Simon GAUDIN on 1/10/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var person : (String, Date, String)?
    {
        didSet
        {
            if let p = person
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                
                nameLabel?.text = p.0
                dateLabel?.text = formatter.string(from: p.1)
                descriptionLabel?.text = p.2
                self.layer.borderWidth = 1.0;
                self.layer.borderColor = UIColor.black.cgColor;
                self.layer.cornerRadius = 8;
            }
        }
    }

}
