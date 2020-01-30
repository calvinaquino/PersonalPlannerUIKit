//
//  DatabaseManager.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Parse

class DatabaseManager {
    
    class func fetchShoppingList(completion: @escaping ([ShoppingSection]) -> Void) {
        DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
            PFObject.pinAll(inBackground: shoppingCategories)
            DatabaseManager.fetchShoppingItems { (shoppingItems) in
                var sections: [ShoppingSection] = []
                let generalCategory = ShoppingCategory()
                generalCategory.name = "Geral"
                let generalSection = ShoppingSection(category: generalCategory, items: shoppingItems.filter({
                    ($0.shoppingCategory == nil)
                }))
                if generalSection.items.count > 0 {
                    sections.append(generalSection)
                }
                for category in shoppingCategories {
                    let section = ShoppingSection(category: category, items: shoppingItems.filter({
                        ($0.shoppingCategory != nil) ? $0.shoppingCategory!.name == category.name : false
                    }))
                    if section.items.count > 0 {
                        sections.append(section)
                    }
                }
                
                completion(sections)
            }
        }
    }
    
    class func fetchShoppingItems(completion: @escaping ([ShoppingItem]) -> Void) {
        if let query = ShoppingItem.query() {
            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
                if let error = error {
                    ErrorUtils.showErrorAler(message: error.localizedDescription)
                } else {
                    if let results = results as? [ShoppingItem] {
                        completion(results)
                    }
                }
            }
        }
    }
    
    class func fetchFinances(for month: Int, year: Int, completion: @escaping ([BudgetSection]) -> Void) {
        DatabaseManager.fetchBudgetCategories { (budgetCategories) in
            PFObject.pinAll(inBackground: budgetCategories)
            DatabaseManager.fetchTransactionsList(for: month, year: year) { (transactionItems) in
                var sections: [BudgetSection] = []
                let generalCategory = BudgetCategory()
                generalCategory.name = "Geral"
                generalCategory.budget = 0
                let generalSection = BudgetSection(category: generalCategory, transactions: transactionItems.filter({
                    ($0.budgetCategory == nil)
                }))
                if generalSection.transactions.count > 0 {
                    sections.append(generalSection)
                }
                for category in budgetCategories {
                    let section = BudgetSection(category: category, transactions: transactionItems.filter({
                        ($0.budgetCategory != nil) ? $0.budgetCategory.name == category.name : false
                    }))
                    if section.transactions.count > 0 {
                        sections.append(section)
                    }
                }
                
                completion(sections)
            }
        }
    }
    
    class func fetchTransactionsList(for month: Int, year: Int, completion: @escaping ([TransactionItem]) -> Void) {
        if let query = TransactionItem.query() {
            query.whereKey("month", equalTo: month)
            query.whereKey("year", equalTo: year)
            query.includeKey("budgetCategory")
            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
                if let error = error {
                    ErrorUtils.showErrorAler(message: error.localizedDescription)
                } else {
                    if let results = results as? [TransactionItem] {
                        completion(results)
                    }
                }
            }
        }
    }
    
    class func fetchBudgetCategories(completion: @escaping ([BudgetCategory]) -> Void) {
        if let query = BudgetCategory.query() {
            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
                if let error = error {
                    ErrorUtils.showErrorAler(message: error.localizedDescription)
                } else {
                    if let results = results as? [BudgetCategory] {
                        completion(results)
                    }
                }
            }
        }
    }
    
    class func fetchBudgetCategories() -> [BudgetCategory]? {
        if let query = BudgetCategory.query() {
            return try? query.findObjects() as? [BudgetCategory]
        }
        return []
    }
    
    class func fetchShoppingCategories(completion: @escaping ([ShoppingCategory]) -> Void) {
        if let query = ShoppingCategory.query() {
            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
                if let error = error {
                    ErrorUtils.showErrorAler(message: error.localizedDescription)
                } else {
                    if let results = results as? [ShoppingCategory] {
                        completion(results)
                    }
                }
            }
        }
    }
    
    class func fetchShoppingCategories() -> [ShoppingCategory]? {
        if let query = ShoppingCategory.query() {
            return try? query.findObjects() as? [ShoppingCategory]
        }
        
        return []
    }
}
