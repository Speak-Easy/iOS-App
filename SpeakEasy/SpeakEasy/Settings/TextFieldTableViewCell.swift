//
//  TextFieldTableViewCell.swift
//  SpeakEasy
//
//  Created by Bryce Langlotz on 5/1/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet var textField:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
