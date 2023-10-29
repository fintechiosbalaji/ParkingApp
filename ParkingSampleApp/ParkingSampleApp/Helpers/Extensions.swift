//
//  Extensions.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//

import Foundation
import UIKit

extension UIButton {
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
