//
//  Cache.swift
//  PlanejadorPessoal
//
//  Created by Calvin De Aquino on 2020-02-19.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

// in memory cache
class Cache: NSObject {
    var shoppingItems: [ShoppingItem]?
    var shoppingCategories: [ShoppingCategory]?
    var transactionItems: [TransactionItem]?
    var transactionCategories: [TransactionCategory]?
    
    static let shared: Cache = {
        let instance = Cache()
        return instance
    }()
}
