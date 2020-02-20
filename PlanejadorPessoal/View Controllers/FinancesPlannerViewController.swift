//
//  FinancesPlannerViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class FinancesPlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate {
    
    var items: [TransactionSection] = []
    var filteredItems: [TransactionSection] = []
    let cellReuseIdentifier = "cell"
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    var monthName: UIBarButtonItem!
    var totalValueBarItem: UIBarButtonItem!
    let calendar: CalendarManager = CalendarManager()
    
    var sections: [TransactionSection] {
        self.searchController.isActive ? self.filteredItems : self.items
    }
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setupNavigationBar()
        self.setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: TransactionCreatedNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.title = "Finanças"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItemTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openBudgetCategoriesOptions))
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        let previousMonthItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(previousMonth))
        let nextMonthItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(nextMonth))
        
        self.monthName = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.totalValueBarItem = UIBarButtonItem(title: "0.00", style: .plain, target: self, action: #selector(askSendRemainingToNextMonth))
        
        self.toolbarItems = [previousMonthItem, UIBarButtonItem.flexibleSpace, self.monthName, UIBarButtonItem.flexibleSpace, self.totalValueBarItem, UIBarButtonItem.flexibleSpace, nextMonthItem]
        self.navigationController?.toolbar.clipsToBounds = true;
    }
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.register(TransactionItemCell.self, forCellReuseIdentifier: TransactionItemCell.Identifier)
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.searchTextField.delegate = self
        self.searchController.searchBar.searchTextField.returnKeyType = .done
        
        self.navigationItem.searchController = self.searchController
        
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Helper Functions
    
    @objc func openBudgetCategoriesOptions() {
        let budgetCategoriesViewController = BudgetCategoriesViewController()
        self.navigationController?.pushViewController(budgetCategoriesViewController, animated: true)
    }
    
    @objc func fetchData() {
        DatabaseManager.fetchFinances(for: calendar.month, year: calendar.year) { (transactionSections) in
            self.items = transactionSections
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.reloadData()
        }
    }
    
    @objc func askSendRemainingToNextMonth() {
        let alert = UIAlertController(title: "Mensagem", message: "Gostaria de enviar esse valor como sobra para o próximo mês?", preferredStyle: UIAlertController.Style.alert )
        
        let yes = UIAlertAction(title: "Sim", style: .default) { (alertAction) in
            let monthLeftOverTransaction = TransactionItem(with: nil)
            self.calendar.nextMonth()
            monthLeftOverTransaction.month = self.calendar.month!
            monthLeftOverTransaction.year = self.calendar.year!
            self.calendar.previousMonth()
            monthLeftOverTransaction.name = "Sobra mes anterior"
            monthLeftOverTransaction.value = self.items.totalTransactions
//            monthLeftOverTransaction.saveInBackground()
        }
        alert.addAction(yes)
        
        let cancel = UIAlertAction(title: "Não", style: .cancel) { (alertAction) in }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func nextMonth() {
        self.calendar.nextMonth()
        self.fetchData()
    }
    
    @objc func previousMonth() {
        self.calendar.previousMonth()
        self.fetchData()
    }
    
    func updateCurrentMonthName() {
        self.monthName.title = calendar.currentMonthAndYear()
    }
    
    func getTotal() -> String {
        self.items.totalTransactions.stringCurrencyValue
    }
    
    @objc func reloadData() {
        if searchController.isActive {
            self.filteredItems = searchController.searchBar.text!.count > 0 ?
                self.items.filterTransactions(with: searchController.searchBar.text!) : self.items
        }
        self.updateCurrentMonthName()
        self.totalValueBarItem.title = self.getTotal()
        self.tableView.reloadData()
    }
    
    // MARK:-  CRUD Functions
    
    @objc func newItem(name: String, price: NSNumber?, month: NSNumber?, year: NSNumber?) {
        let newTransactionItem = TransactionItem(with: nil)
        newTransactionItem.name = name
        newTransactionItem.value = price?.doubleValue ?? 0.0
        newTransactionItem.month = month?.intValue ?? calendar.month
        newTransactionItem.year = year?.intValue ?? calendar.year
        newTransactionItem.save { (record, error) in
            self.fetchData()
        }
    }
    
    @objc func removeItem(at row: Int) {
        self.items.remove(at: row)
        self.reloadData()
    }
    
    @objc func newItemTapped() {
        self.openTransactionItemForm(forItem: nil)
    }
    
    @objc func openTransactionItemForm(forItem item: TransactionItem? = nil) {
        DatabaseManager.preloadTransactionCategories()
        let form = TransactionFormViewController(transaction: item)
        self.present(form.withNavigation(), animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDeletate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TransactionItemCell.Identifier, for: indexPath) as! TransactionItemCell
        let transactionItem = self.sections.transaction(at: indexPath)
        cell.textLabel?.text = transactionItem.name
        cell.detailTextLabel?.text = transactionItem.value!.stringCurrencyValue
        cell.detailTextLabel?.textColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let transactionItem = self.sections.transaction(at: indexPath)
        let transactionFormViewControler = TransactionFormViewController(transaction: transactionItem)
        self.present(transactionFormViewControler.withNavigation(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let transactionItem = self.sections.transaction(at: indexPath)
            transactionItem.delete { (recordId, error) in
                if error == nil {
                    self.fetchData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let sectionForTotal = self.items.filter { $0.category?.objectId == section.category?.objectId }.first
        if section.category == nil {
            return section.categoryName
        }
        let remaining = section.categoryBudget + sectionForTotal!.total
        return "\(section.categoryName)  (\(remaining.stringCurrencyValue))"
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        self.reloadData()
    }
    
    // MARK: - UITextFieldDelegate
    
    //  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //    if let searchText = textField.text {
    //      if searchText.count > 0 && self.filteredItems.count == 0 {
    //        self.showNewItemDialog(itemName: searchText)
    //      }
    //    }
    //    return true
    //  }
}
