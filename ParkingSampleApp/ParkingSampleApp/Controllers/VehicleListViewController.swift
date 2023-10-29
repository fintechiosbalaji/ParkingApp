//
//  VehicleListViewController.swift
//  ParkingSampleApp
//
//  Created by Balaji  on 29/10/23.
//


import UIKit
import CoreData

class VehicleListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var parkedVehicles: [ParkingTicket] = []
    var filteredVehicles: [ParkingTicket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableViewCell()
        self.setupSearchController()
        parkedVehicles = fetchParkedVehicles()
        filteredVehicles = fetchParkedVehicles()
    }
    
    func setupSearchController() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Vehicles"
    
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundColor = .black
        if let placeholderLabel = searchBar.searchTextField.value(forKey: "placeholderLabel") as? UILabel {
            placeholderLabel.textColor = .black
        }
        
    }
    
    // Handle search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredVehicles = parkedVehicles.filter { vehicle in
                return vehicle.ticketno?.contains(searchText) ?? false
            }
        } else {
            filteredVehicles = parkedVehicles
        }
        tableView.reloadData()
    }
    
    // MARK: Setup TableView
    func setupTableViewCell() {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        let nib = UINib(nibName: "UnparkTableViewCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "UnparkTableViewCell")
        tableView.reloadData()
    }
    
    // Fetch parked vehicles from Core Data
    func fetchParkedVehicles() -> [ParkingTicket] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ParkingTicket> = ParkingTicket.fetchRequest()
        
        do {
            let vehicles = try context.fetch(fetchRequest)
            return vehicles
        } catch {
            print("Error fetching parked vehicles: \(error)")
            return []
        }
    }
    
    // Calculate parking fees based on the duration and vehicle type
    func calculateParkingFee(for vehicle: ParkingTicket) -> Double {
        
        guard let entryTime = vehicle.entrytime else { return 0.00}
        
        let exitTime = Date()
        
        let timeInterval = exitTime.timeIntervalSince(entryTime)
        let hoursParked = timeInterval / 3600
        
        if let vehicleType = VehicleType(rawValue: vehicle.vehicletype ?? "") {
            switch vehicleType {
            case .motorcycle:
                return calculateMotorcycleFee(hoursParked)
            case .car, .bus:
                return calculateCarOrBusFee(hoursParked)
            }
        }
        return 0.0
    }
    
    func calculateMotorcycleFee(_ hoursParked: Double) -> Double {
        if hoursParked < 4 {
            return 30.0
        } else if hoursParked < 12 {
            return 60.0
        } else {
            let additionalHours = hoursParked - 12
            return 60.0 + additionalHours * 100.0
        }
    }
    
    func calculateCarOrBusFee(_ hoursParked: Double) -> Double {
        if hoursParked < 4 {
            return 60.0
        } else if hoursParked < 12 {
            return 120.0
        } else {
            let additionalHours = hoursParked - 12
            return 120.0 + additionalHours * 200.0
        }
    }
   
    func unparkVehicle(_ vehicle: ParkingTicket) {
        // Calculate parking fees
        let parkingFee = calculateParkingFee(for: vehicle)
        let alertController = UIAlertController(title: "Unpark Vehicle", message: "Total Fee: ₹\(parkingFee)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(vehicle)
                do {
                    try context.save()
                } catch {
                    print("Error saving context after unparking: \(error)")
                }
            }
            self?.reloadData() // Reload the table view data.
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        filteredVehicles = fetchParkedVehicles()
        tableView.reloadData()
    }
}

extension VehicleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnparkTableViewCell", for: indexPath) as! UnparkTableViewCell
        
        let vehicle = filteredVehicles[indexPath.row]
        cell.selectionStyle = .none
        cell.ticketNo?.text = "TicketNo: #\(vehicle.ticketno ?? "")"
        cell.categoryNo?.text = "ID: \(vehicle.vehicletype ?? "N/A")\nEntry: \(formatDate(vehicle.entrytime))\nSpotNo:\(vehicle.spot)"
        cell.onclick = {
            self.unparkVehicle(vehicle)
        }
        return cell
    }
    
    // format a date as a string
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
            return formatter.string(from: date)
        }
        return "N/A"
    }
}

