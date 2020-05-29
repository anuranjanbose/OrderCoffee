//
//  OrdersTableViewController.swift
//  OrderCoffee
//
//  Created by Anuranjan Bose on 19/04/20.
//  Copyright © 2020 Anuranjan Bose. All rights reserved.
//

import Foundation
import UIKit

enum SegueIdentifier: String {
    case addOrderVC = "AddOrderViewController"
}

protocol AddOrderDelegate: class {
    func addOrderDidSave()
}

class OrdersTableViewController: UITableViewController {
   
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.addOrderVC.rawValue {
            if let vc = segue.destination as? AddOrderViewController {
                vc.delegate = self
            }
        }
    }
    
    private func populateOrders() {
                
        Webservice().load(resource: Order.all) { [weak self] result in
            
            switch result {
                case .success(let orders):
                   self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                   self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell 
        
    }
    
}

// MARK: - Add Order Delegate
extension OrdersTableViewController: AddOrderDelegate {
    func addOrderDidSave() {
        self.populateOrders()
    }
}
