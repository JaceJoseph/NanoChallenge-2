//
//  RoundedButton.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 19/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }

}
