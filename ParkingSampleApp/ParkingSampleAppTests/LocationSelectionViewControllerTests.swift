//
//  LocationSelectionViewController.swift
//  ParkingSampleAppTests
//
//  Created by Balaji  on 29/10/23.
//

import XCTest
@testable import ParkingSampleApp

final class LocationSelectionViewControllerTests: XCTestCase {
    
    var viewController: LocationSelectionViewController!
    
    override func setUp() {
        super.setUp()
        self.viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSelectionViewController") as? LocationSelectionViewController
        self.viewController.loadView()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testSelectParkingAction() {
     
        let theatreButton = viewController.theatreBtn
        let mallButton = viewController.mallBtn

        theatreButton?.sendActions(for: .touchUpInside)
        mallButton?.sendActions(for: .touchUpInside)
  
    }
}
