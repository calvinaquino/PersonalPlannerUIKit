//
//  TransactionItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation

class TransactionItem: Record {
    override class var recordType: String {
        "TransactionItem"
    }
    
    var name: String!
    var location: String!
    var value: NSNumber!
    var day: NSNumber!
    var month: NSNumber!
    var year: NSNumber!
    var budgetCategory: TransactionCategory!
}
