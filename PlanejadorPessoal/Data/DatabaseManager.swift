//
//  DatabaseManager.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Apollo

class DatabaseManager {
//    static let shared = Network()
    static let shared = DatabaseManager()
    let apollo: ApolloClient = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "X-Parse-Application-Id": "0z5F3IL3II8MdllpO09MtGqnXoUA9Jqlq5jtftxN",
            "X-Parse-Client-Key": "nT7eXhKNJcBTMb8DlsdOwJAlhndYkYtI432iyxce"
        ]
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://parseapi.back4app.com/graphql")!

        return ApolloClient(
            networkTransport: HTTPNetworkTransport(
                url: url,
                session: session
            )
        )
    }()
    static var client: ApolloClient {
        DatabaseManager.shared.apollo
    }
    
    class func fetchShoppingList(completion: @escaping ([ShoppingSection]) -> Void) {
        DatabaseManager.client.fetch(query: ShoppingListQuery(), resultHandler: {result in
            switch result {
            case .success:
//                if let launchConnection = graphQLResult.data?.launches {
//                  self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
//                }
                
//                var shoppingItems: [ShoppingItem] = []
                if let shoppingItemsConnection = try? result.get().data?.shoppingItems {
//                    shoppingItems.append(contentsOf: )
                    print(shoppingItemsConnection.results)
//                    shoppingItems = shoppingItemsConnection.results.map({ (shoppingItemResult) -> ShoppingItem in
//                        <#code#>
//                    })
                    for itemm in shoppingItemsConnection.resultMap {
                        print(itemm)
                    // print(itemm)
                    }
                    for itemm in shoppingItemsConnection.results {
                        print(itemm.jsonObject)
                    // print(itemm)
                    }
                }
                
//                let results = try? result.get().data!.shoppingItems.resultMap;
//                let shoppingItems =  results.map { (itemResult) -> ShoppingItem in
////                    itemResult[0].n
//                    print(itemResult)
//                    return ShoppingItem()
//                }
//                print(shoppingItems)
                completion([])
            case .failure(let error):
                print(error)
            }
        })
        
//        DatabaseManager.shared.apollo.fetch(query: ShoppingListQuery)
//            switch result {
//            case .success: break
//                // success
//            case .failure(let error):
//                print(error)
//            }
//        }
//        apollo.fetch(query: HeroNameQuery(episode: .empire)) { result in
//          guard let data = try? result.get().data else { return }
//          print(data.hero?.name) // Luke Skywalker
//        }
        
        
//        DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
//            PFObject.pinAll(inBackground: shoppingCategories)
//            DatabaseManager.fetchShoppingItems { (shoppingItems) in
//                var sections: [ShoppingSection] = []
//                let generalCategory = ShoppingCategory()
//                generalCategory.name = "Geral"
//                let generalSection = ShoppingSection(category: generalCategory, items: shoppingItems.filter({
//                    ($0.shoppingCategory == nil)
//                }))
//                if generalSection.items.count > 0 {
//                    sections.append(generalSection)
//                }
//                for category in shoppingCategories {
//                    let section = ShoppingSection(category: category, items: shoppingItems.filter({
//                        ($0.shoppingCategory != nil) ? $0.shoppingCategory!.name == category.name : false
//                    }))
//                    if section.items.count > 0 {
//                        sections.append(section)
//                    }
//                }
//
//                completion(sections)
//            }
//        }
        completion([])
    }
    
    class func fetchShoppingItems(completion: @escaping ([ShoppingItem]) -> Void) {
//        if let query = ShoppingItem.query() {
//            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
//                if let error = error {
//                    ErrorUtils.showErrorAler(message: error.localizedDescription)
//                } else {
//                    if let results = results as? [ShoppingItem] {
//                        completion(results)
//                    }
//                }
//            }
//        }
        completion([])
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
    
    class func fetchBudgetCategories(completion: @escaping ([BudgetCategory]) -> Void) {
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
    
    class func fetchBudgetCategories() -> [BudgetCategory]? {
//        if let query = BudgetCategory.query() {
//            return try? query.findObjects() as? [BudgetCategory]
//        }
        return []
    }
    
    class func fetchShoppingCategories(completion: @escaping ([ShoppingCategory]) -> Void) {
//        if let query = ShoppingCategory.query() {
//            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
//                if let error = error {
//                    ErrorUtils.showErrorAler(message: error.localizedDescription)
//                } else {
//                    if let results = results as? [ShoppingCategory] {
//                        completion(results)
//                    }
//                }
//            }
//        }
        completion([])
    }
    
    class func fetchShoppingCategories() -> [ShoppingCategory]? {
//        if let query = ShoppingCategory.query() {
//            return try? query.findObjects() as? [ShoppingCategory]
//        }
        
        return []
    }
}
