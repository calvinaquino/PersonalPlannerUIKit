//
//  TransactionItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Parse

class TransactionItem: PFObject, PFSubclassing {
  static func parseClassName() -> String {
    "TransactionItem"
  }
  
  @NSManaged var name: String!
  @NSManaged var value: NSNumber!
  @NSManaged var month: NSNumber!
  @NSManaged var year: NSNumber!
  @NSManaged var budgetCategory: BudgetCategory!
  
//  var budgetCategory: BudgetCategory? {
//    get {
//      self.value(forKey: "budgetCategory") as? BudgetCategory
//    }
//    set {
//      self.setValue(newValue, forKey: "budgetCategory")
//    }
//  }
}