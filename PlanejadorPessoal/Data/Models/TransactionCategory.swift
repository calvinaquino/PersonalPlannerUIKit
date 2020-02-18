//
//  BudgetCategory.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/15/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

// Not used until I resolve the nested PFObject issue on subclass
import Foundation
import CloudKit

class TransactionCategory: Record {
    override class var recordType: String {
        "TransactionCategory"
    }
    
    var name: String! {
        get { self.ckRecord["name"] }
        set { self.ckRecord["name"] = newValue! }
    }
    var budget: Double? {
        get { self.ckRecord["budget"] }
        set { self.ckRecord["budget"] = newValue }
    }
}

struct TransactionSection {
    var category: TransactionCategory?
    var transactions: [TransactionItem]
    
    var categoryName: String {
        category?.name ?? "Geral"
    }
    
    var categoryBudget: Double {
        category?.budget ?? 0.0
    }
    
    var total: Double {
        self.transactions.reduce(0) { $1.value + $0 }
    }
}

extension Array where Iterator.Element == TransactionSection {
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
                filteredSections.append(TransactionSection(category: section.category, transactions: filteredTransactions))
            }
        }
        
        return filteredSections
    }
    
    func transaction(at indexPath: IndexPath) -> TransactionItem {
        let section = self[indexPath.section]
        return section.transactions[indexPath.row]
    }
}
