//
//  VehicleEntryViewController.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//


import UIKit
import CoreData

class VehicleEntryViewController: UIViewController {
    
    @IBOutlet var scooterButton: UIButton!
    @IBOutlet var carButton: UIButton!
    @IBOutlet var busButton: UIButton!
    @IBOutlet var parkButton: UIButton!{
        didSet{
            self.parkButton.roundCorners(radius: 10)
        }
    }
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    
    var selectedVehicleType: VehicleType?
    private var entryTime: Date?
    public var selectedLocation: ParkingCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scooterButton.tag = 1
        carButton.tag = 2
        busButton.tag = 3
    }
    
    // Handle vehicle selection
    @IBAction func selectVehicle(_ sender: UIButton) {
        for button in [scooterButton, carButton, busButton] {
            button?.tintColor = .systemBlue // Set the default tint color
        }
        switch sender.tag {
        case 1:
            selectedVehicleType = .motorcycle
        case 2:
            selectedVehicleType = .car
        case 3:
            selectedVehicleType = .bus
        default:
            selectedVehicleType = nil
        }
        sender.tintColor = .orange
        parkButton.backgroundColor = .orange
        vehicleTypeLbl.text = self.selectedVehicleType?.rawValue
    }
    
    // Handle "Unpark" action
    @IBAction func unParkActn(_ sender: UIBarItem) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleListViewController") as?  VehicleListViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Handle submission of vehicle entry
    @IBAction func parkAction(_ sender: UIButton) {
        if selectedVehicleType != nil {
            if let selectedType = selectedVehicleType, let selectedLocation = selectedLocation {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let availableSpots = getAvailableSpots(vehicleType: selectedType, location: selectedLocation, context: context)
                print("availableSpots:\(availableSpots.first ?? 0)")
                
                if availableSpots.count > 0 {
                    
                    // Generate a unique registration number
                    let ticketNumber = generateUniqueTicketNumber(context: context)
                    
                    // Create a new Vehicle entity
                    let vehicle = ParkingTicket(context: context)
                    vehicle.vehicletype = selectedType.rawValue
                    vehicle.ticketno = ticketNumber // Set the unique ticket number
                    vehicle.location = selectedLocation.rawValue
                    vehicle.entrytime = Date()
                    vehicle.isAllocated = true
                    vehicle.spot = Int16(availableSpots.first ?? 0)
                    print("spotNumber:\(availableSpots.first ?? 0)")
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                } else {
                    showSpotLimitReachedAlert(for: selectedVehicleType ?? .motorcycle, viewController: self)
                }
            }
        } else {
            print("Select Vechile")
        }
    }
}

// Helper functions
extension VehicleEntryViewController {
    
    func getAvailableSpots(vehicleType: VehicleType, location: ParkingCategory, context: NSManagedObjectContext) -> [Int] {
        
        guard let predefinedSpotsForLocation = ParkingSpots.predefinedSpots[location],
              let predefinedLimit = predefinedSpotsForLocation[vehicleType] else {
            return []
        }
        
        let fetchRequest: NSFetchRequest<ParkingTicket> = ParkingTicket.fetchRequest()
        let vehicleTypePredicate = NSPredicate(format: "vehicletype == %@", vehicleType.rawValue)
        let locationPredicate = NSPredicate(format: "location == %@", location.rawValue)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [vehicleTypePredicate, locationPredicate])
        
        fetchRequest.predicate = compoundPredicate
        
        do {
            let occupiedTickets = try context.fetch(fetchRequest)
            let spotNumbers = occupiedTickets.compactMap { Int($0.spot) }
            let predefinedArray = Array(1...predefinedLimit)
            let availableSpotNumbers = predefinedArray.filter { !spotNumbers.contains($0) }
            return availableSpotNumbers
        } catch {
            return []
        }
    }
    
    func generateUniqueTicketNumber(context: NSManagedObjectContext) -> String {
        var registrationNumber = ""
        repeat {
            let randomNumber = Int(arc4random_uniform(900) + 100) // Generates a random number from 100 to 999
            registrationNumber = String(format: "%03d", randomNumber) // Format as a 3-digit string
        } while registrationNumberExists(registrationNumber: registrationNumber, context: context)
        return registrationNumber
    }
    
    func registrationNumberExists(registrationNumber: String, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<ParkingTicket> = ParkingTicket.fetchRequest()
        request.predicate = NSPredicate(format: "ticketno == %@", registrationNumber)
        do {
            let matchingVehicles = try context.fetch(request)
            return !matchingVehicles.isEmpty
        } catch {
            return true 
        }
    }
    
    func showSpotLimitReachedAlert(for vehicleType: VehicleType, viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Spot Limit Reached",
            message: "All spots for \(vehicleType.rawValue) are fully allocated.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
