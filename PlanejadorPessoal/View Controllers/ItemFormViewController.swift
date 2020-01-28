//
//  ItemFormViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ItemFormViewController: FormViewController {
    
    var item: ShoppingItem?
    
    convenience init(item: ShoppingItem? = nil) {
        self.init()
        self.title = item != nil ? "Editar Item" : "Criar Item"
        if let item = item {
            self.item = item
        } else {
            self.item = ShoppingItem()
        }
    }
    
    // MARK: - Helper
    
    func getCategoryOptions() -> [FieldOption] {
        if let categories = DatabaseManager.fetchShoppingCategories() {
            return categories.map({ (shoppingCategory) -> FieldOption in
                return FieldOption(id: shoppingCategory.objectId!, name: shoppingCategory.name)
            })
        }
        return []
    }
    
    // MARK: - Required By Subclass
    
    override func setupFormFields() -> [FormField] {
        return [
            FormField(name: "Nome", type: .TextInput, value: self.item?.name, didChange: {self.item?.name = $0}),
            FormField(name: "Nome Inglês", type: .TextInput, value: self.item?.localizedName, didChange: {self.item?.localizedName = $0}),
            FormField(name: "Preço", type: .TextInput, value: self.item?.price?.currencyString, didChange: {self.item?.price = $0.numberValue}),
            FormField(name: "Categoria", type: .Selection, value: self.item?.shoppingCategory?.name, options: self.getCategoryOptions, didChange: {
//                let selectedCategory = ShoppingCategory(withoutDataWithObjectId: $0)
//                selectedCategory.fetchIfNeededInBackground { (_, error) in
//                    self.fields[3].value = self.item?.shoppingCategory?.name
//                    self.tableView.reloadData()
//                }
                self.item?.shoppingCategory = ShoppingCategory(withoutDataWithObjectId: $0)
                self.item?.shoppingCategory?.fetchIfNeededInBackground(block: { (shoppingCategory, error) in
                    self.fields[3].value = self.item?.shoppingCategory?.name
                    self.tableView.reloadData()
                })
            })
        ]
    }
    
    @objc override func save() {
//        self.item
        self.item?.saveInBackground(block: { (success, error) in
            //
        })
    }

}
