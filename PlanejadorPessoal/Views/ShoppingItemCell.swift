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
    
    var isNeeded: Bool = true {
        didSet {
            self.accessoryView = self.isNeeded ? UIImageView(image: UIImage(systemName: "cube.box")) : UIImageView(image: UIImage(systemName: "cube.box.fill"))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.accessoryView = self.isNeeded ? UIImageView(image: UIImage(systemName: "cube.box")) : UIImageView(image: UIImage(systemName: "cube.box.fill"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
