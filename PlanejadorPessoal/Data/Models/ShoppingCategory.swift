//
//  ShoppingCategory.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/20/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Parse

class ShoppingCategory: PFObject, PFSubclassing {
  static func parseClassName() -> String {
    "ShoppingCategory"
  }
  
  @NSManaged var name: String!
}

struct ShoppingSection {
    var category: ShoppingCategory
    var items: [ShoppingItem]
//    var hidden: Bool = false
    
    var total: Double {
        self.items.reduce(0) { ($1.isNeeded.boolValue ? 1 : 0) + $0 }
    }
}

extension Array where Iterator.Element == ShoppingSection {
    
    func hasItem(with name: String) -> Bool {
        for section in self {
            let match = section.items.filter{ $0.name == name }.first != nil
            if match {
                return true
            }
        }
        return false
    }
    
    var itemCount: Int {
        var total = 0
        for section in self {
            total = total + section.items.count
        }
        return total
    }
    
    func filterItems(with name: String) -> Self {
        var filteredSections: [Element] = []
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", name)
        for section in self {
            let filteredItems = section.items.filter({searchPredicate.evaluate(with: $0.name)})
            if (filteredItems.count > 0) {
                filteredSections.append(ShoppingSection(category: section.category, items: filteredItems))
            }
        }
        
        return filteredSections
    }
    
    func item(at indexPath: IndexPath) -> ShoppingItem {
        let section = self[indexPath.section]
        return section.items[indexPath.row]
    }
}
