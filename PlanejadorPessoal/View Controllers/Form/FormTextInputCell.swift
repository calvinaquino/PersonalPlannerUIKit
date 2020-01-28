//
//  FormTextInputCell.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class FormTextInputCell: UITableViewCell {
    
    static let Identifier = "FormTextInputCell"
    
    var textField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        
        self.textField = UITextField()
        self.textField.font = UIFont.systemFont(ofSize: 14)
        self.textField.textColor = .darkGray
        self.contentView.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10.0
        self.textField.top = margin
        self.textField.left = self.textLabel!.right + margin
        self.textField.bottom = self.contentView.height - margin
        self.textField.right = self.contentView.width - margin
    }
    
}
