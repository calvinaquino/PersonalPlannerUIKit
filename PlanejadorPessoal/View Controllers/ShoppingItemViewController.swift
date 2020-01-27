//
//  ShoppingItemViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/26/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

let ItemCreatedNotification = Notification.Name("ItemCreated")

class ShoppingItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var shoppingItem: ShoppingItem?
    var shoppingCategories: [ShoppingCategory] = []
    
    var categoryPicker: UIPickerView!
    var localizedNameTextField: UITextField!
    var nameTextField: UITextField!
    var priceTextField: UITextField!
    
    convenience init(shoppingItem: ShoppingItem) {
        self.init()
        self.shoppingItem = shoppingItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = shoppingItem != nil ? "Editar item" : "Novo item"
        self.modalPresentationStyle = .formSheet
        self.view.backgroundColor = .white
        
        configureNavigationBar()
        configureForm()
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .done, target: self, action: #selector(cancel))
    }
    
    func configureForm() {
        self.nameTextField = UITextField()
        self.localizedNameTextField = UITextField()
        self.priceTextField = UITextField()
        self.categoryPicker = UIPickerView()
        self.nameTextField.delegate = self
        self.localizedNameTextField.delegate = self
        self.priceTextField.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.localizedNameTextField)
        self.view.addSubview(self.priceTextField)
        self.view.addSubview(self.categoryPicker)
        
        self.nameTextField.placeholder = "Nome do item"
        self.localizedNameTextField.placeholder = "Nome do item em Inglês"
        self.priceTextField.placeholder = "Preço estimado do item"
        self.priceTextField.keyboardType = .numbersAndPunctuation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
            self.shoppingCategories = shoppingCategories
            self.categoryPicker.reloadAllComponents()
            
            if let item = self.shoppingItem {
                self.nameTextField.text = item.name
                self.localizedNameTextField.text = item.localizedName
                self.priceTextField.text = item.price!.currencyString
                let row = item.shoppingCategory != nil ? self.shoppingCategories.firstIndex { $0.objectId == item.shoppingCategory!.objectId}?.advanced(by: 1) : 0
                self.categoryPicker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nameTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let margin: CGFloat = 16.0
        self.nameTextField.top = self.view.safeAreaTop
        self.nameTextField.left = margin
        self.nameTextField.right = self.view.right - margin
        self.nameTextField.height = 40
        self.localizedNameTextField.top = self.nameTextField.bottom + margin
        self.localizedNameTextField.left = margin
        self.localizedNameTextField.right = self.view.right - margin
        self.localizedNameTextField.height = 40
        self.priceTextField.top = self.localizedNameTextField.bottom + margin
        self.priceTextField.left = margin
        self.priceTextField.right = self.view.right - margin
        self.priceTextField.height = 40
        self.categoryPicker.top = self.priceTextField.bottom + margin
        self.categoryPicker.left = margin
        self.categoryPicker.right = self.view.right - margin
        self.categoryPicker.height = 200
    }
    
    // MARK: - Helpr Funtions
    
    @objc func save() {
        var item: ShoppingItem!
        if self.shoppingItem == nil {
            // new item
            item = ShoppingItem()
        } else {
            // existing item
            item = self.shoppingItem
        }
        item.name = self.nameTextField.text
        item.localizedName = self.localizedNameTextField.text
        let priceValue = Double(self.priceTextField.text ?? "0")
        item.price = priceValue?.numberValue
        let selectedCategoryRow = self.categoryPicker.selectedRow(inComponent: 0)
        item.shoppingCategory = selectedCategoryRow != 0 ? self.shoppingCategories[selectedCategoryRow - 1] : nil
        item.saveInBackground { (success, error) in
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: ItemCreatedNotification, object: nil)
            }
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.localizedNameTextField.becomeFirstResponder()
        } else if textField == self.localizedNameTextField {
            self.priceTextField.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.shoppingCategories.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            return "Geral"
        }
        let shoppingCategory = self.shoppingCategories[row - 1]
        return shoppingCategory.name!
    }
    
}
