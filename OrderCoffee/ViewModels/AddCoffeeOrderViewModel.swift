//
//  AddCoffeeOrderViewModel.swift
//  OrderCoffee
//
//  Created by Anuranjan Bose on 19/04/20.
//  Copyright © 2020 Anuranjan Bose. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String? 
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
    
}
