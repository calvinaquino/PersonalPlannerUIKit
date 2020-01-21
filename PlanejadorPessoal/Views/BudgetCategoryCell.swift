//
//  BudgetCategoryCell.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/20/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class BudgetCategoryCell: UITableViewCell {
  
  static let Identifier = "BudgetCategoryCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
