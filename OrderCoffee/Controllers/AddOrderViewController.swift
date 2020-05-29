//
//  AddOrderViewController.swift
//  OrderCoffee
//
//  Created by Anuranjan Bose on 19/04/20.
//  Copyright © 2020 Anuranjan Bose. All rights reserved.
//

import Foundation
import UIKit

enum AddOrderValidation {
    case name
    case email
    case size
    case coffee
    case none
    
    var message: String {
        switch self {
        case .name, .email:
            return "Both name and email is mandatory"
        case .size:
            return "Select size"
        case .coffee:
            return "Select Type of Coffee"
        case .none:
            return ""
        }
    }
}

class AddOrderViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: Properties
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    private var addOrderValidation: AddOrderValidation = .none
    weak var delegate: AddOrderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true 
    
    }
    
    // MARK: IBActions
    @IBAction func save() {
        
        guard let name = self.nameTextField.text, let email = self.emailTextField.text, name != "", email != "" else {
            /// showAlert
            addOrderValidation = .name
            print("Enter both Name and Email")
            showAlert()
            return
        }
        guard self.coffeeSizesSegmentedControl.selectedSegmentIndex > -1 else {
            ///showAlert
            print("Select Size")
            addOrderValidation = .size
            showAlert()
            return
        }
        guard let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex) else {
            print("Select Size")
            return
        }
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            //fatalError("Error in selecting coffee!")
            addOrderValidation = .coffee
            showAlert()
            return
        }
        
        
        self.vm.name = name
        self.vm.email = email
        
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            
            switch result {
                case .success(let order):
                    print(order as Any)
                    self.addOrder()
                case .failure(let error):
                    print(error)
            }
            
        }
        
    }
    
    @IBAction func dismissView() {
        
        guard let nav = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        nav.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: UITableView Delegate and Datasource
extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
       }
       
       func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.vm.types.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
           
           cell.textLabel?.text = self.vm.types[indexPath.row]
           return cell
       }
}

// MARK: Helper Methods
extension AddOrderViewController {
    
    private func addOrder() {
        guard let nav = self.navigationController else {
            self.dismiss(animated: true, completion: {[unowned self] in
                self.delegate?.addOrderDidSave()
            })
            
            return
        }
        nav.dismiss(animated: true, completion: {[unowned self] in
            self.delegate?.addOrderDidSave()
        })
    }
    
    private func showAlert() {
        if addOrderValidation != .none {
            let alert = UIAlertController(title: "Data Required", message: addOrderValidation.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
