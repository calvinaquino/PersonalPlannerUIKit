//
//  ShoppingItem.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation

class ShoppingItem: NSObject {
  var name: String!
  var localizedName: String?
  var price: NSNumber?
  var isNeeded: NSNumber!
  var shoppingCategory: ShoppingCategory?
}

