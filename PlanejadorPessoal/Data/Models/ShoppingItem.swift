//
//  ShoppingItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import CloudKit

class ShoppingItem: Record {
    override class var recordType: String {
        "ShoppingItem"
    }

    var name: String! {
        get { self.ckRecord["name"] }
        set { self.ckRecord["name"] = newValue }
    }
    var localizedName: String? {
        get { self.ckRecord["localizedName"] }
        set { self.ckRecord["localizedName"] = newValue }
    }
    var price: Double? {
        get { self.ckRecord["price"] }
        set { self.ckRecord["price"] = newValue! }
    }
    var isNeeded: Bool! {
        get { self.ckRecord["isNeeded"] }
        set { self.ckRecord["isNeeded"] = newValue}
    }
    
    var shoppingCategory: ShoppingCategory? {
        get {
            if let reference = self.ckRecord["shoppingCategory"] as? CKRecord.Reference {
                let record = CKRecord(recordType: ShoppingCategory.recordType, recordID: reference.recordID)
                return ShoppingCategory(with: record)
            }
            return nil
        }
        set {
            if let newShoppingCategory = newValue {
                let reference = CKRecord.Reference(recordID: newShoppingCategory.ckRecord!.recordID, action: .none)
                self.ckRecord["shoppingCategory"] = reference
            } else {
                self.ckRecord["shoppingCategory"] = nil
            }
        }
    }
    
    override var debugDescription: String {
        "Item - name: \(name ?? ""), price: \(price ?? 0.0)"
    }
}

