//
//  ItemFormViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

let ItemCreatedNotification = Notification.Name("ItemCreated")

class ItemFormViewController: FormViewController {
    
    var item: ShoppingItem?
    
    convenience init(item: ShoppingItem? = nil) {
        self.init()
        self.title = item != nil ? "Editar Item" : "Criar Item"
        if let item = item {
            self.item = item
        } else {
            self.item = ShoppingItem(with: nil)
        }
    }
    
    // MARK: - Helper
    
    func getCategoryOptions() -> [FieldOption] {
        var fieldOptions = DatabaseManager.cachedShoppingCategories().map({ (shoppingCategory) -> FieldOption in
            return FieldOption(id: shoppingCategory.objectId, name: shoppingCategory.name)
        })
        fieldOptions.append(FieldOption(id: "", name: "Geral"))
        return fieldOptions
    }
    
    // MARK: - Required By Subclass
    
    override func setupFormFields() -> [FormField] {
        // Name
        var nameField = FormField(name: "Nome", type: .TextInput, value: self.item?.name)
        nameField.didChange = {
            self.fields[0].value = $0
            self.tableView.reloadData()
        }
        // Name English
        var nameLocalizedField = FormField(name: "Nome Inglês", type: .TextInput, value: self.item?.localizedName)
        nameLocalizedField.didChange = {
            self.fields[1].value = $0
            self.tableView.reloadData()
        }
        // Price
        var priceField = FormField(name: "Preço", type: .TextInput, value: self.item?.price?.stringCurrencyValue)
        priceField.didChange = {
            self.fields[2].value = $0
            self.tableView.reloadData()
        }
        // Category
        var categoryField = FormField(name: "Categoria", type: .Selection, value: self.item?.shoppingCategory?.name ?? "Geral", options: self.getCategoryOptions)
        categoryField.didChange = {
            if $0 == "" {
                self.fields[3].value = "Geral"
                self.tableView.reloadData()
            } else {
                let newCategory = ShoppingCategory(withObjectId: $0)
                newCategory.fetch { (record, error) in
                    DispatchQueue.main.async {
                        self.fields[3].value = newCategory.name
                        self.tableView.reloadData()
                    }
                }
            }
        }
        return [
            nameField,
            nameLocalizedField,
            priceField,
            categoryField
        ]
    }
    
    @objc override func onSave() {
        if let item = self.item {
            item.name = self.fields[0].value
            item.localizedName = self.fields[1].value
            item.price = self.fields[2].value?.doubleValue
            DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
                item.shoppingCategory = shoppingCategories.filter({ $0.name == self.fields[3].value }).first
                item.save { (record, error) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: ItemCreatedNotification, object: nil)
                        }
                    }
                }
            }
        }
    }

}
