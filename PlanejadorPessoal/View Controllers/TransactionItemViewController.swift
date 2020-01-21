//
//  EditShoppingItemViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

let TransactionCreatedNotification = Notification.Name("TransactionCreated")

class TransactionItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  var transactionItem: TransactionItem?
  var budgetCategories: [BudgetCategory] = []
  var month: Int?
  var year: Int?
  
  var categoryPicker: UIPickerView!
  var nameTextField: UITextField!
  var priceTextField: UITextField!
  
  convenience init(transactionItem: TransactionItem) {
    self.init()
    self.transactionItem = transactionItem
  }
  
  convenience init(month: Int, year: Int) {
    self.init()
    self.month = month
    self.year = year
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = transactionItem != nil ? "Editar transação" : "Nova transação"
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
    self.priceTextField = UITextField()
    self.categoryPicker = UIPickerView()
    self.nameTextField.delegate = self
    self.priceTextField.delegate = self
    self.categoryPicker.delegate = self
    self.categoryPicker.dataSource = self
    self.view.addSubview(self.nameTextField)
    self.view.addSubview(self.priceTextField)
    self.view.addSubview(self.categoryPicker)
    
    self.nameTextField.placeholder = "Nome da transação"
    
    self.priceTextField.placeholder = "Preço da transação"
    self.priceTextField.keyboardType = .decimalPad
  }
  
  func withNavigation() -> UIViewController {
    UINavigationController(rootViewController: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DatabaseManager.fetchBudgetCategories { (budgetCategories) in
      self.budgetCategories = budgetCategories
      self.categoryPicker.reloadAllComponents()
      
      if let transactionItem = self.transactionItem {
        self.nameTextField.text = transactionItem.name
        self.priceTextField.text = transactionItem.value.stringCurrency
        let row = self.budgetCategories.firstIndex { $0.objectId == transactionItem.budgetCategory.objectId}
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
    self.priceTextField.top = self.nameTextField.bottom + margin
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
    var transactionItem: TransactionItem!
    if self.transactionItem == nil {
      // new item
      transactionItem = TransactionItem()
      transactionItem.month = NSNumber(value: self.month!)
      transactionItem.year = NSNumber(value: self.year!)
    } else {
      // existing item
      transactionItem = self.transactionItem
    }
    transactionItem.name = self.nameTextField.text
    let priceValue = Double(self.priceTextField.text ?? "0")
    transactionItem.value = priceValue?.numberValue
    transactionItem.budgetCategory = self.budgetCategories[self.categoryPicker.selectedRow(inComponent: 0)]
    transactionItem.saveInBackground { (success, error) in
      self.dismiss(animated: true) {
        NotificationCenter.default.post(name: TransactionCreatedNotification, object: nil)
      }
    }
  }
  
  @objc func cancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == self.nameTextField {
      self.priceTextField.becomeFirstResponder()
    }
    return true
  }
  
  // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    self.budgetCategories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let budgetCatetory = self.budgetCategories[row]
    return "\(budgetCatetory.name!) (\(budgetCatetory.budget!.stringCurrency))"
  }
  
}
