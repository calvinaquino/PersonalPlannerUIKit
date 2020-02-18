//
//  DatabaseManager.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit
import CloudKit

class DatabaseManager {
    
    class var database: CKDatabase {
        let container = CKContainer.default()
        return container.privateCloudDatabase
    }
    
    class var zoneID: CKRecordZone.ID {
        CKRecordZone.default().zoneID
    }
    
    class func queryOperation(for recordType: Record.Type) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType.recordType, predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.database = database
        return queryOperation
    }
    
    class func errorAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ops! Tivemos um problema:", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert )
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    class func fetchShoppingList(completion: @escaping ([ShoppingSection]) -> Void) {
        DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
            DatabaseManager.fetchShoppingItems { (shoppingItems) in
                var sections: [ShoppingSection] = []
                let generalSection = ShoppingSection(category: nil, items: shoppingItems.filter({
                    ($0.shoppingCategory == nil)
                }))
                if generalSection.items.count > 0 {
                    sections.append(generalSection)
                }
                for category in shoppingCategories {
                    print(category.debugDescription)
                    let section = ShoppingSection(category: category, items: shoppingItems.filter({
                        ($0.shoppingCategory != nil) ? $0.shoppingCategory!.objectId == category.objectId : false
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
        var shoppingItems: [ShoppingItem] = []
        let fetchOperation = queryOperation(for: ShoppingItem.self)
        fetchOperation.database = database
        fetchOperation.recordFetchedBlock = { record in
            shoppingItems.append(ShoppingItem(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            print(shoppingItems)
            DispatchQueue.main.async {
                completion(shoppingItems)
            }
        }
        fetchOperation.start()
    }
    
    class func fetchFinances(for month: Int, year: Int, completion: @escaping ([BudgetSection]) -> Void) {
//        DatabaseManager.fetchBudgetCategories { (budgetCategories) in
//            PFObject.pinAll(inBackground: budgetCategories)
//            DatabaseManager.fetchTransactionsList(for: month, year: year) { (transactionItems) in
//                var sections: [BudgetSection] = []
//                let generalCategory = BudgetCategory()
//                generalCategory.name = "Geral"
//                generalCategory.budget = 0
//                let generalSection = BudgetSection(category: generalCategory, transactions: transactionItems.filter({
//                    ($0.budgetCategory == nil)
//                }))
//                if generalSection.transactions.count > 0 {
//                    sections.append(generalSection)
//                }
//                for category in budgetCategories {
//                    let section = BudgetSection(category: category, transactions: transactionItems.filter({
//                        ($0.budgetCategory != nil) ? $0.budgetCategory.name == category.name : false
//                    }))
//                    if section.transactions.count > 0 {
//                        sections.append(section)
//                    }
//                }
//
//                completion(sections)
//            }
//        }
        completion([])
    }
    
    class func fetchTransactionsList(for month: Int, year: Int, completion: @escaping ([TransactionItem]) -> Void) {
//        if let query = TransactionItem.query() {
//            query.whereKey("month", equalTo: month)
//            query.whereKey("year", equalTo: year)
//            query.includeKey("budgetCategory")
//            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
//                if let error = error {
//                    ErrorUtils.showErrorAler(message: error.localizedDescription)
//                } else {
//                    if let results = results as? [TransactionItem] {
//                        completion(results)
//                    }
//                }
//            }
//        }
        completion([])
    }
    
    class func fetchBudgetCategories(completion: @escaping ([TransactionCategory]) -> Void) {
//        if let query = BudgetCategory.query() {
//            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
//                if let error = error {
//                    ErrorUtils.showErrorAler(message: error.localizedDescription)
//                } else {
//                    if let results = results as? [BudgetCategory] {
//                        completion(results)
//                    }
//                }
//            }
//        }
        completion([])
    }
    
    class func fetchBudgetCategories() -> [TransactionCategory]? {
//        if let query = BudgetCategory.query() {
//            return try? query.findObjects() as? [BudgetCategory]
//        }
        return []
    }
    
    class func fetchShoppingCategories(completion: @escaping ([ShoppingCategory]) -> Void) {
        var shoppingCategories: [ShoppingCategory] = []
        let fetchOperation = queryOperation(for: ShoppingCategory.self)
        fetchOperation.recordFetchedBlock = { record in
            shoppingCategories.append(ShoppingCategory(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            print(shoppingCategories)
            DispatchQueue.main.async {
                completion(shoppingCategories)
            }
        }
        fetchOperation.start()
    }
    
    class func fetchShoppingCategories() -> [ShoppingCategory]? {
//        if let query = ShoppingCategory.query() {
//            return try? query.findObjects() as? [ShoppingCategory]
//        }
        
        return []
    }
}
