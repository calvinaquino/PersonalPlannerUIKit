//
//  FinancesPlannerViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/12/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class FinancesPlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate {
  
  var items: [TransactionItem] = []
  var filteredItems: [TransactionItem] = []
  let cellReuseIdentifier = "cell"
  var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  var searchController: UISearchController!
  var monthName: UIBarButtonItem!
  var totalValueBarItem: UIBarButtonItem!
  let calendar: CalendarManager = CalendarManager()
  
  // MARK: - LifeCycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    
    self.setupNavigationBar()
    self.setupTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super .viewDidAppear(animated)
    
    fetchData()
  }
  
  override func viewDidLayoutSubviews() {
    self.tableView.frame = self.view.bounds
  }
  
  // MARK: - Setup Functions
  
  func setupNavigationBar() {
    self.title = "Finanças"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItemTapped))
    self.navigationController?.setToolbarHidden(false, animated: false)
    
    let previousMonthItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(previousMonth))
    let nextMonthItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(nextMonth))
    
    self.monthName = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.monthName.isEnabled = false
    self.totalValueBarItem = UIBarButtonItem(title: "0.00", style: .plain, target: nil, action: nil)
    self.totalValueBarItem.isEnabled = false
    
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
  
  @objc func fetchData() {
    DatabaseManager.fetchFinances(for: calendar.month, year: calendar.year) { (transactionItems) in
      self.items = transactionItems
      if self.refreshControl.isRefreshing {
        self.refreshControl.endRefreshing()
      }
      self.reloadData()
    }
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
  
  func nameAlreadyExists(name: String) -> Bool {
    return self.items.filter{ $0.name == name }.first == nil
  }
  
  func getTotal() -> String {
    let total = self.items.reduce(0) { $1.value.doubleValue + $0 }
    return String(format: "%.2f", total)
  }
  
  func getItems() -> [TransactionItem] {
    return self.searchController.isActive ? self.filteredItems : self.items
  }
  
  func reloadData() {
    if searchController.isActive {
      let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
      self.filteredItems = searchController.searchBar.text!.count > 0 ?
        self.items.filter({searchPredicate.evaluate(with: $0.name)}) : self.items
    }
    self.updateCurrentMonthName()
    self.totalValueBarItem.title = self.getTotal()
    self.tableView.reloadData()
  }
  
  // MARK:-  CRUD Functions
  
  @objc func newItem(name: String, price: NSNumber?, month: NSNumber?, year: NSNumber?) {
    let newTransactionItem = TransactionItem()
    newTransactionItem.name = name
    newTransactionItem.value = price ?? 0
    newTransactionItem.month = month ?? NSNumber(value: calendar.month)
    newTransactionItem.year = year ?? NSNumber(value: calendar.year)
    newTransactionItem.saveInBackground().continueOnSuccessWith(block: { (_) -> Any? in
      self.fetchData()
    })
  }
  
  @objc func removeItem(at row: Int) {
    self.items.remove(at: row)
    self.reloadData()
  }
  
  @objc func newItemTapped() {
    self.showNewItemDialog()
  }
  
  @objc func showNewItemDialog(itemName: String? = nil) {
    let alert = UIAlertController(title: "Nova transação", message: "Insira os dados da transação:", preferredStyle: UIAlertController.Style.alert )
    
    let save = UIAlertAction(title: "Finalizar", style: .default) { (alertAction) in
      let nameTextField = alert.textFields![0] as UITextField
      let priceTextField = alert.textFields![1] as UITextField
//      let monthTextField = alert.textFields![2] as UITextField
      
      if let name = nameTextField.text, let price = priceTextField.text {
        if name != "" && price != "" {
          self.newItem(name: name, price: NSNumber(value: Float(price) ?? 0.0), month: NSNumber(value: self.calendar.month), year: NSNumber(value: self.calendar.year))
        } else {
          ErrorUtils.showErrorAler(message: "Campo do nome ou preço vazios.")
        }
      }
      
    }
    
    alert.addTextField { (textField) in
      textField.placeholder = "Nome"
      if let name = itemName {
        textField.text = name
      }
    }
    alert.addTextField { (textField) in
      textField.placeholder = "Preço"
    }
    
    alert.addAction(save)
    let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (alertAction) in }
    alert.addAction(cancel)
    
    self.present(alert, animated:true, completion: nil)
  }
  
  // MARK: - UITableViewDeletate, UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchController.isActive ? self.filteredItems.count : self.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: TransactionItemCell.Identifier, for: indexPath) as! TransactionItemCell
    
    let transactionItem = self.getItems()[indexPath.row]
    cell.textLabel?.text = transactionItem.name
    cell.detailTextLabel?.text = "\(transactionItem.value!)"
    cell.detailTextLabel?.textColor = .gray
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
//    let TransactionItem = self.getItems()[indexPath.row]
//    TransactionItem.saveInBackground().continueOnSuccessWith { (_) -> Any? in
//      self.fetchData()
//    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let transactionItem = self.getItems()[indexPath.row]
      transactionItem.deleteInBackground { (success: Bool, error: Error?) in
        if let error = error {
          print(error.localizedDescription)
        } else if success {
          self.fetchData()
        }
      }
    }
  }
  
  // MARK: - UISearchResultsUpdating
  
  func updateSearchResults(for searchController: UISearchController) {
    self.reloadData()
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let searchText = textField.text {
      if searchText.count > 0 && self.filteredItems.count == 0 {
        self.showNewItemDialog(itemName: searchText)
      }
    }
    return true
  }
}
