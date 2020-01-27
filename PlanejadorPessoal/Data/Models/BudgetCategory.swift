//
//  BudgetCategory.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/15/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

// Not used until I resolve the nested PFObject issue on subclass
import Foundation
import Parse

class BudgetCategory: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        "BudgetCategory"
    }
    
    @NSManaged var name: String!
    @NSManaged var budget: NSNumber?
}

struct BudgetSection {
    var category: BudgetCategory
    var transactions: [TransactionItem]
//    var hidden: Bool = false
    
    var total: Double {
        self.transactions.reduce(0) { $1.value.doubleValue + $0 }
    }
}

extension Array where Iterator.Element == BudgetSection {
    var totalTransactions: Double {
        var total = 0.0
        for section in self {
            total = total + section.total
        }
        return total
    }
    
    var transactionCount: Int {
        var total = 0
        for section in self {
            total = total + section.transactions.count
        }
        return total
    }
    
    func filterTransactions(with name: String) -> Self {
        var filteredSections: [Element] = []
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", name)
        for section in self {
            let filteredTransactions = section.transactions.filter({searchPredicate.evaluate(with: $0.name)})
            if (filteredTransactions.count > 0) {
                filteredSections.append(BudgetSection(category: section.category, transactions: filteredTransactions))
            }
        }
        
        return filteredSections
    }
    
    func transaction(at indexPath: IndexPath) -> TransactionItem {
        let section = self[indexPath.section]
        return section.transactions[indexPath.row]
    }
}
