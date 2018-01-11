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
    
    var person : (String, String)?
    {
        didSet
        {
            if let p = person
            {
                nameLabel?.text = p.0
                descriptionLabel?.text = p.1
                self.layer.borderWidth = 1.0;
                self.layer.borderColor = UIColor.black.cgColor;
            }
        }
    }

}
