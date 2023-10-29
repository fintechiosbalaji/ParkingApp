//
//  UnparkTableViewCell.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//

import UIKit

class UnparkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ticketNo: UILabel!
    @IBOutlet weak var categoryNo: UILabel!
    @IBOutlet weak var unparkBtn: UIButton!{
        didSet{
            unparkBtn.roundCorners(radius: 10)
        }
    }
    
    public var onclick: (()-> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unparkActn(_ sender: UIButton) {
        self.onclick?()
    }
    
}
