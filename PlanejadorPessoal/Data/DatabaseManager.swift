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
    
    class func queryOperation(for recordType: Record.Type, predicate: NSPredicate = NSPredicate(value: true)) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType.recordType, predicate: predicate)
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
    
    class func fetchFinances(for month: Int, year: Int, completion: @escaping ([TransactionSection]) -> Void) {
        DatabaseManager.fetchTransactionCategories { (transactionCategories) in
            DatabaseManager.fetchTransactionItems(for: month, year: year) { (transactionItems) in
                var sections: [TransactionSection] = []
                let generalSection = TransactionSection(category: nil, transactions: transactionItems.filter({
                    ($0.transactionCategory == nil)
                }))
                if generalSection.transactions.count > 0 {
                    sections.append(generalSection)
                }
                for category in transactionCategories {
                    print(category.debugDescription)
                    let section = TransactionSection(category: category, transactions: transactionItems.filter({
                        ($0.transactionCategory != nil) ? $0.transactionCategory!.objectId == category.objectId : false
                    }))
                    if section.transactions.count > 0 {
                        sections.append(section)
                    }
                }
                completion(sections)
            }
        }
        
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
    
    class func fetchTransactionItems(for month: Int, year: Int, completion: @escaping ([TransactionItem]) -> Void) {
        var transactionItems: [TransactionItem] = []
        let monthPredicate = NSPredicate(format: "month == %@", month)
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [monthPredicate, yearPredicate])
        let fetchOperation = queryOperation(for: TransactionItem.self, predicate: compoundPredicate)
        fetchOperation.recordFetchedBlock = { record in
            transactionItems.append(TransactionItem(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            print(transactionItems)
            DispatchQueue.main.async {
                completion(transactionItems)
            }
        }
        fetchOperation.start()
    }
    
    class func fetchTransactionCategories(completion: @escaping ([TransactionCategory]) -> Void) {
        var transactionCategories: [TransactionCategory] = []
        let fetchOperation = queryOperation(for: TransactionCategory.self)
        fetchOperation.recordFetchedBlock = { record in
            transactionCategories.append(TransactionCategory(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            print(transactionCategories)
            DispatchQueue.main.async {
                completion(transactionCategories)
            }
        }
        fetchOperation.start()
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
