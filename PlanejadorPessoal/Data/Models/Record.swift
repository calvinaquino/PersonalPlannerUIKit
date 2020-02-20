//
//  Record.swift
//  PlanejadorPessoal
//
//  Created by Calvin De Aquino on 2020-02-17.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit
import CloudKit

class Record: NSObject {
    open var ckRecord: CKRecord!
    var deleted: Bool = false
    
    var objectId: String {
        self.ckRecord.recordID.recordName
    }
    
    var recordId: CKRecord.ID {
        self.ckRecord.recordID
    }
    
    required init(with record: CKRecord?) {
        super.init()
        self.ckRecord = record ?? Record.newCKRecord(recordType: Self.recordType)
    }
    
    convenience init(withObjectId objectId: String) {
        let recordId = CKRecord.ID(recordName: objectId)
        let record = CKRecord(recordType: Self.recordType, recordID: recordId)
        self.init(with: record)
    }
    
    class var recordType: String {
        fatalError("recordType needs to be implemented by subclass")
    }
    
    class func newCKRecord(recordType: String) -> CKRecord {
        let recordId = CKRecord.ID(recordName: UUID().uuidString)
        return CKRecord(recordType: recordType, recordID: recordId)
    }
    
    final func save(completion: @escaping (CKRecord?, Error?) -> Void) {
        DatabaseManager.modify(save: self, delete: nil) { completion(self.ckRecord, $2) }
    }
    
    final func fetch(completion: @escaping (CKRecord?, Error?) -> Void) {
        DatabaseManager.fetch(self) { completion($0.ckRecord, $1) }
    }
    
    final func delete(completion: @escaping (CKRecord.ID?, Error?) -> Void) {
        DatabaseManager.modify(save: nil, delete: self) {
            self.deleted = true
            completion(self.recordId, $2)
        }
    }
}
