//
//  FormSelectInputCell.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

let expandedExtraHeight: CGFloat = 160.0

class FormSelectInputCell: UITableViewCell {
    
    static let Identifier = "FormSelectInputCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        self.detailTextLabel?.textColor = .darkGray
        self.detailTextLabel?.text = "Geral"
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10.0
        self.detailTextLabel?.top = margin
        self.detailTextLabel?.left = self.textLabel!.right + margin
        self.detailTextLabel?.bottom = self.contentView.height - margin
        self.detailTextLabel?.right = self.contentView.width - margin
    }
    
}
