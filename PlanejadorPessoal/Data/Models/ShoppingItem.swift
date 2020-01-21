//
//  ShoppingItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Parse

class ShoppingItem: PFObject, PFSubclassing {
  static func parseClassName() -> String {
    "ShoppingItem"
  }
  
  @NSManaged var name: String!
  @NSManaged var localizedName: String?
  @NSManaged var price: NSNumber?
  @NSManaged var isNeeded: NSNumber!
  @NSManaged var shoppingCategory: ShoppingCategory?
}
