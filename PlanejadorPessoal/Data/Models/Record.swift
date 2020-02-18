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
    
    var objectId: String {
        self.ckRecord.recordID.recordName
    }
    
    required init(with record: CKRecord?) {
        super.init()
        self.ckRecord = record ?? Record.newCKRecord(recordType: Self.recordType)
    }
    
    class var recordType: String {
        fatalError("recordType needs to be implemented by subclass")
    }
    
    class func newCKRecord(recordType: String) -> CKRecord {
        let recordId = CKRecord.ID(recordName: UUID().uuidString)
        return CKRecord(recordType: recordType, recordID: recordId)
    }
    
    final func save(completion: @escaping (CKRecord?, Error?) -> Void) {
        DatabaseManager.database.save(self.ckRecord, completionHandler: completion)
    }
}
