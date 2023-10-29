//
//  VehicleEntryViewControllerTests.swift
//  ParkingSampleAppTests
//
//  Created by Balaji  on 29/10/23.
//

import XCTest
@testable import ParkingSampleApp
import CoreData

final class VehicleEntryViewControllerTests: XCTestCase {
    
    var viewController: VehicleEntryViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleEntryViewController") as? VehicleEntryViewController
        viewController.loadView()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testSelectVehicle() {
        // Simulate tapping the scooterButton
        viewController.selectVehicle(viewController.scooterButton)
        
        // Assert that selectedVehicleType and UI changes are as expected
        XCTAssertEqual(viewController.scooterButton.tintColor, .orange)
        XCTAssertEqual(viewController.parkButton.backgroundColor, .orange)
        XCTAssertEqual(viewController.vehicleTypeLbl.text, "")
    }
    
    func testUnParkActn() {
        // Assuming your "Unpark" action pushes a new view controller
        viewController.unParkActn(UIBarButtonItem())
    }
    
    func testGenerateUniqueTicketNumber() {
        let context = createMockContext()
        
        // Call the function to generate a unique ticket number
        let ticketNumber = viewController.generateUniqueTicketNumber(context: context)
        
        // Assert that the generated ticket number is valid (e.g., it's unique and has the expected format)
        XCTAssertTrue(ticketNumber.count == 3)
        // You may want to test for uniqueness, but that depends on your data setup and requirements.
    }
    
    // You can add more test cases for other methods as needed.
    
    // Helper function to create a mock NSManagedObjectContext for testing
    private func createMockContext() -> NSManagedObjectContext {
        // Create an in-memory NSPersistentStoreCoordinator for testing
        let model = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Create an NSManagedObjectContext with the in-memory coordinator
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        return context
    }
}
