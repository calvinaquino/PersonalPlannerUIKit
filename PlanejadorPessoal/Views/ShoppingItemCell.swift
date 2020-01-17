//
//  ShoppingItemCell.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {
  
  static let Identifier = "ShoppingItemCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
