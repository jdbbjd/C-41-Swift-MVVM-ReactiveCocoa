//
//  LyTextFieldCell.swift
//  Swift-C41
//
//  Created by ly on 16/8/2.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit

class LyTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
