//
//  TransactionItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import CloudKit

class TransactionItem: Record {
    override class var recordType: String {
        "TransactionItem"
    }
    
    var name: String! {
        get { self.ckRecord["name"] }
        set { self.ckRecord["name"] = newValue! }
    }
    var location: String! {
        get { self.ckRecord["location"] }
        set { self.ckRecord["location"] = newValue! }
    }
    var value: Double! {
        get { self.ckRecord["value"] }
        set { self.ckRecord["value"] = newValue! }
    }
    var day: Int! {
        get { self.ckRecord["day"] }
        set { self.ckRecord["day"] = newValue! }
    }
    var month: Int! {
        get { self.ckRecord["month"] }
        set { self.ckRecord["month"] = newValue! }
    }
    var year: Int! {
        get { self.ckRecord["year"] }
        set { self.ckRecord["year"] = newValue! }
    }
    
    var transactionCategory: TransactionCategory? {
        get {
            if let reference = self.ckRecord["transactionCategory"] as? CKRecord.Reference {
                let record = CKRecord(recordType: TransactionCategory.recordType, recordID: reference.recordID)
                return TransactionCategory(with: record)
            }
            return nil
        }
        set {
            if let newShoppingCategory = newValue {
                let reference = CKRecord.Reference(recordID: newShoppingCategory.ckRecord!.recordID, action: .none)
                self.ckRecord["transactionCategory"] = reference
            } else {
                self.ckRecord["transactionCategory"] = nil
            }
        }
    }
}
