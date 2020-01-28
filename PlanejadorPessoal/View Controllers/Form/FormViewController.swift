//
//  FormViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView: UITableView!
    var fields: [FormField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = transactionItem != nil ? "Editar transação" : "Nova transação"
        self.modalPresentationStyle = .formSheet
        self.view.backgroundColor = .white
        
        self.setupNavigationBar()
        self.setupTableView()
        self.fields = self.setupFormFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .done, target: self, action: #selector(cancel))
    }
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.register(FormTextInputCell.self, forCellReuseIdentifier: FormTextInputCell.Identifier)
        self.tableView.register(FormSelectInputCell.self, forCellReuseIdentifier: FormSelectInputCell.Identifier)
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Required By Subclass
    
    open func setupFormFields() -> [FormField] {
        fatalError("\"setupFormFields\" needs implementation by subclass")
    }
    
    @objc open func save() {
        fatalError("\"save\" needs implementation by subclass")
    }
    
    // MARK: - Helper Funtions
    
    @objc func cancel() {
      self.dismiss(animated: true, completion: nil)
    }
    
    func getCell<T: UITableViewCell>(_ row: Int) -> T? {
        return self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? T ?? nil
    }
    
    func getTextField(forTag tag: Int) -> UITextField? {
        let cell: FormTextInputCell? = self.getCell(tag)
        return cell?.textField
    }
    
    func getNextTextFieldIfPossible(current tag: Int) -> UITextField? {
        let cell: FormTextInputCell? = self.getCell(tag + 1)
        return cell?.textField
    }
    
    // MARK: - UITableViewDeletate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = self.fields[indexPath.row]
        switch field.type {
        case .Selection:
            return self.renderSelectionCell(for: field, at: indexPath)
        case .TextInput:
            return self.renderTextInputCell(for: field, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = self.fields[indexPath.row]
        if field.type == .Selection {
            self.tableView.deselectRow(at: indexPath, animated: true)
            guard let getOptions = field.options, let didChange = field.didChange else {
                return
            }
            DispatchQueue.global(qos: .background).async {
                let options = getOptions()
                DispatchQueue.main.async {
                    let optionsList = UIAlertController(title: nil, message: "Escolha a opção", preferredStyle: .actionSheet)
                    
                    for option in options {
                        let selectOption = UIAlertAction(title: option.name, style: .default, handler: {(alert) -> Void in
                            didChange(option.id)
                            self.tableView.reloadData()
                        })
                        optionsList.addAction(selectOption)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    optionsList.addAction(cancelAction)
                    self.present(optionsList, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Cell Rendering Functions
    
    func renderTextInputCell(for field: FormField, at indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FormTextInputCell.Identifier, for: indexPath) as! FormTextInputCell
        
        cell.textLabel?.text = field.name
        cell.textField?.delegate = self
        cell.textField?.placeholder = field.name
        cell.textField?.text = field.value
        cell.textField?.tag = indexPath.row
        return cell
    }
    
    func renderSelectionCell(for field: FormField, at indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FormSelectInputCell.Identifier, for: indexPath) as! FormSelectInputCell
        
        cell.textLabel?.text = field.name
        cell.detailTextLabel?.text = field.value
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let field = self.fields[textField.tag]
        if field.type == .TextInput {
            if let cell = self.getCell(textField.tag) as? FormTextInputCell {
                field.didChange?(cell.textField.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.getNextTextFieldIfPossible(current: textField.tag) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
