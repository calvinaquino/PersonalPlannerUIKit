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
  class func fetchShoppingList(completion: @escaping ([ShoppingItem]) -> Void) {
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
}
