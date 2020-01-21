//
//  ShoppingCategory.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/20/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation
import Parse

class ShoppingCategory: PFObject, PFSubclassing {
  static func parseClassName() -> String {
    "ShoppingCategory"
  }
  
  @NSManaged var name: String!
}
