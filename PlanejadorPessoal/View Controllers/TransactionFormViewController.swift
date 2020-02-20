//
//  TransactionFormViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/28/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

let TransactionCreatedNotification = Notification.Name("TransactionCreated")

class TransactionFormViewController: FormViewController {
    
    var transaction: TransactionItem?
    
    convenience init(transaction: TransactionItem? = nil) {
        self.init()
        self.title = transaction != nil ? "Editar Transação" : "Criar Transação"
        if let item = transaction {
            self.transaction = item
        } else {
            let newItem = TransactionItem(with: nil)
            newItem.value = 0
            newItem.day = Calendar.current.component(.day, from: Date())
            newItem.month = (Calendar.current.component(.month, from: Date()) - 1)
            newItem.year = Calendar.current.component(.year, from: Date())
            self.transaction = newItem
        }
    }
    
    // MARK: - Helper
    
    func getCategoryOptions() -> [FieldOption] {
        return DatabaseManager.cachedTransactionCategories().map({ (transactionCategory) -> FieldOption in
            return FieldOption(id: transactionCategory.objectId, name: transactionCategory.name)
        })
    }
    
    func getYears() -> [FieldOption] {
        // get 1 year pass and 2 years future
        let previousYear = Calendar.current.component(.year, from: Date()) - 1
        var yearOptions: [FieldOption] = []
        for year in previousYear...previousYear + 3 {
            let yearString = String(year)
            yearOptions.append(FieldOption(id: yearString, name: yearString))
        }
        return yearOptions
    }
    
    func getMonths() -> [FieldOption] {
        // get all month names
        var monthOptions: [FieldOption] = []
        for monthIndex in 0...11 {
            let monthName = DateFormatter().monthSymbols[monthIndex]
            monthOptions.append(FieldOption(id: String(monthIndex), name: monthName))
        }
        return monthOptions
    }
    
    func getDays() -> [FieldOption] {
        // get all days for selected month
        var month = self.transaction?.month
        if let monthFromField = self.fields[4].value {
            month = Int(monthFromField)
        }
        
        let year = Calendar.current.component(.year, from: Date())
        var components = DateComponents(year: year, month: month);
        let firstDay = Calendar.current.date(from: components)
        components.month = month! + 1
        components.day = -1
        let lastDay = Calendar.current.date(from: components)
        let daysInMonth = Calendar.current.dateComponents([.day], from: firstDay!, to: lastDay!).day
        var days: [FieldOption] = []
        for day in 1...daysInMonth! {
            days.append(FieldOption(id: String(day), name: String(day)))
        }
        return days
    }
    
    // MARK: - Required By Subclass
    
    override func setupFormFields() -> [FormField] {
        // Name
        var nameField = FormField(name: "Nome", type: .TextInput, value: self.transaction?.name)
        nameField.didChange = {
            self.fields[0].value = $0
            self.tableView.reloadData()
        }
        // Price
        var priceField = FormField(name: "Preço", type: .TextInput, value: self.transaction?.value?.stringCurrencyValue)
        priceField.didChange = {
            self.fields[1].value = $0
            self.tableView.reloadData()
        }
        // Category
        var categoryField = FormField(name: "Categoria", type: .Selection, value: self.transaction?.transactionCategory?.name, options: self.getCategoryOptions)
        categoryField.didChange = {
            if $0 == "" {
                self.fields[2].value = "Geral"
                self.tableView.reloadData()
            } else {
                let newCategory = TransactionCategory(withObjectId: $0)
                newCategory.fetch { (record, error) in
                    DispatchQueue.main.async {
                        self.fields[2].value = newCategory.name
                        self.tableView.reloadData()
                    }
                }
            }
        }
        // Day
        var dayField = FormField(name: "Dia", type: .Selection, value: self.transaction?.day?.stringValue, options: self.getDays)
        dayField.didChange = {
            self.fields[3].value = $0
            self.tableView.reloadData()
        }
        // Month
        var monthField = FormField(name: "Mês", type: .Selection, value: self.transaction?.month.stringValue, options: self.getMonths)
        monthField.didChange = {
            self.fields[4].value = $0
            self.tableView.reloadData()
        }
        monthField.valueFormat = {
            DateFormatter().monthSymbols[$0.intValue]
        }
        // Year
        var yearField = FormField(name: "Ano", type: .Selection, value: self.transaction?.year.stringValue, options: self.getYears)
        yearField.didChange = {
            self.fields[5].value = $0
            self.tableView.reloadData()
        }
        
        return [
            nameField,
            priceField,
            categoryField,
            dayField,
            monthField,
            yearField
        ]
    }
    
    @objc override func onSave() {
        if let item = self.transaction {
            item.name = self.fields[0].value
            item.value = self.fields[1].value?.doubleValue
            DatabaseManager.fetchTransactionCategories { (transactionCategories) in
                item.transactionCategory = transactionCategories.filter({ $0.name == self.fields[2].value }).first
                item.save { (record, error) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: TransactionCreatedNotification, object: nil)
                        }
                    }
                }
            }
        }
    }

}
