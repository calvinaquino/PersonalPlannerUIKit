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
            print(error.localizedDescription)
        } else {
          if let results = results as? [ShoppingItem] {
            completion(results)
          }
        }
      }
    }
  }
  
  class func fetchFinances(completion: @escaping ([ShoppingItem]) -> Void) {
//    if let query = ShoppingItem.query() {
//      query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
//        if let error = error {
//            print(error.localizedDescription)
//        } else {
//          if let results = results as? [ShoppingItem] {
//            completion(results)
//          }
//        }
//      }
//    }
  }
}
