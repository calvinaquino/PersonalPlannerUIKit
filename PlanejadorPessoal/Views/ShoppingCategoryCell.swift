//
//  ShoppingCategoryCell.swift
//  PlanejadorPessoal
//
//  Created by Calvin De Aquino on 2020-02-01.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ShoppingCategoryCell: UITableViewCell {
  
  static let Identifier = "ShoppingCategoryCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

