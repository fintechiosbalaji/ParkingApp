//
//  LocationSelectionViewController.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//

import UIKit

class LocationSelectionViewController: UIViewController {
    
    @IBOutlet weak var theatreBtn: UIButton!{
        didSet{
            theatreBtn.roundCorners(radius: 10)
        }
    }
    @IBOutlet weak var mallBtn: UIButton!{
        didSet{
            mallBtn.roundCorners(radius: 10)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectParkingActn(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleEntryViewController") as?  VehicleEntryViewController {
            vc.selectedLocation = sender.tag == 1 ? .theatre : .mall
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
