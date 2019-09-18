//
//  ReflectionTableViewCell.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 17/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit

class ReflectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(title:String){
        self.titleLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}