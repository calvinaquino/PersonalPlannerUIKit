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
    
    class var cache: Cache {
        Cache.shared
    }
    
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
    
    class func modifyBatch(save: [Record], delete: [Record], completion: @escaping (Error?) -> Void) {
        let recordsToSave = save.map{$0.ckRecord!}
        let recordIDsToDelete = delete.map{$0.recordId}
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
        modifyRecordsOperation.database = DatabaseManager.database
        let configuration = CKOperation.Configuration()
        configuration.qualityOfService = .userInitiated
        modifyRecordsOperation.configuration = configuration
        modifyRecordsOperation.modifyRecordsCompletionBlock = { _, _, error in
            completion(error)
        }
        modifyRecordsOperation.start()
    }
    
    class func modify(save: Record?, delete: Record?, completion: @escaping (Record?, Record?, Error?) -> Void) {
        print("modify operation requested")
        let modifyRecordsOperation = CKModifyRecordsOperation()
        if let save = save {
            modifyRecordsOperation.recordsToSave = [save.ckRecord]
        }
        if let delete = delete {
            modifyRecordsOperation.recordIDsToDelete = [delete.recordId]
        }
        modifyRecordsOperation.database = DatabaseManager.database
        let configuration = CKOperation.Configuration()
        configuration.qualityOfService = .userInitiated
        modifyRecordsOperation.configuration = configuration
        modifyRecordsOperation.modifyRecordsCompletionBlock = { saved, deleted, error in
            print("modify operation completed")
            completion(save, delete, error)
        }
        modifyRecordsOperation.start()
    }
    
    class func fetch(_ record: Record, completion: @escaping (Record, Error?) -> Void) {
        print("fetch operation requested")
        let fetchOperation = CKFetchRecordsOperation(recordIDs: [record.recordId])
        fetchOperation.database = DatabaseManager.database
        let configuration = CKOperation.Configuration()
        configuration.qualityOfService = .userInitiated
        fetchOperation.configuration = configuration
        fetchOperation.perRecordCompletionBlock = { fetchedRecord, fetchedRecordId, error in
            record.ckRecord = fetchedRecord
        }
        fetchOperation.fetchRecordsCompletionBlock = { _, error in
            print("fetch operation completed")
            completion(record, error)
        }
        fetchOperation.start()
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
        print("query items operation requested")
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
            DispatchQueue.main.async {
                print("query items operation completed")
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
    }
    
    class func fetchTransactionItems(for month: Int, year: Int, completion: @escaping ([TransactionItem]) -> Void) {
        print("query transactions operation requested")
        var transactionItems: [TransactionItem] = []
        let monthPredicate = NSPredicate(format: "month == %@", month.numberValue)
        let yearPredicate = NSPredicate(format: "year == %@", year.numberValue)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [monthPredicate, yearPredicate])
        let fetchOperation = queryOperation(for: TransactionItem.self, predicate: compoundPredicate)
        fetchOperation.recordFetchedBlock = { record in
            transactionItems.append(TransactionItem(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            DispatchQueue.main.async {
                print("query transactions operation completed")
                completion(transactionItems)
            }
        }
        fetchOperation.start()
    }
    
    class func fetchTransactionCategories(completion: @escaping ([TransactionCategory]) -> Void) {
        print("query transactions categories operation requested")
        var transactionCategories: [TransactionCategory] = []
        let fetchOperation = queryOperation(for: TransactionCategory.self)
        fetchOperation.recordFetchedBlock = { record in
            transactionCategories.append(TransactionCategory(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            DatabaseManager.cache.transactionCategories = transactionCategories
            DispatchQueue.main.async {
                print("query transactions categories operation completed")
                completion(transactionCategories)
            }
        }
        fetchOperation.start()
    }
    
    class func fetchShoppingCategories(completion: @escaping ([ShoppingCategory]) -> Void) {
        print("query shopping categories operation requested")
        var shoppingCategories: [ShoppingCategory] = []
        let fetchOperation = queryOperation(for: ShoppingCategory.self)
        fetchOperation.recordFetchedBlock = { record in
            shoppingCategories.append(ShoppingCategory(with: record))
        }
        fetchOperation.queryCompletionBlock = { cursor, error in
            if let error = error {
                self.errorAlert(error: error)
            }
            DatabaseManager.cache.shoppingCategories = shoppingCategories
            DispatchQueue.main.async {
                print("query shopping categories operation completed")
                completion(shoppingCategories)
            }
        }
        fetchOperation.start()
    }
    
    class func preloadTransactionCategories() {
        DatabaseManager.fetchTransactionCategories { (transactionCategories) in
            DatabaseManager.cache.transactionCategories = transactionCategories
        }
    }
    
    class func cachedTransactionCategories() -> [TransactionCategory] {
        return DatabaseManager.cache.transactionCategories ?? []
    }
    
    class func preloadShoppingCategories() {
        DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
            DatabaseManager.cache.shoppingCategories = shoppingCategories
        }
    }
    
    class func cachedShoppingCategories() -> [ShoppingCategory] {
        return DatabaseManager.cache.shoppingCategories ?? []
    }
}
