//
//  AvailableDeviceCell.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 15/04/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import UIKit

class AvailableDeviceCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with title: String) {
        self.title.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
