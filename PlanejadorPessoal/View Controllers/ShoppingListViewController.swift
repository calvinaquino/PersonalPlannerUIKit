//
//  ShoppingListViewController.swift
//  Planejador Pessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/11/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate {
  
  var items: [ShoppingItem] = []
  var filteredItems: [ShoppingItem] = []
  let cellReuseIdentifier = "cell"
  var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  var searchController: UISearchController!
  
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
    self.title = "Mercado"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewItemDialog))
  }
  
  func setupTableView() {
    self.tableView = UITableView()
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
    DatabaseManager.fetchShoppingList { (shoppingItems) in
      self.items = shoppingItems
      if self.refreshControl.isRefreshing {
        self.refreshControl.endRefreshing()
      }
      self.reloadData()
    }
  }
  
  func nameAlreadyExists(name: String) -> Bool {
    return self.items.filter{ $0.name == name }.first == nil
  }
  
  func getItems() -> [ShoppingItem] {
    return self.searchController.isActive ? self.filteredItems : self.items
  }
  
  func reloadData() {
    if searchController.isActive {
      let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
      self.filteredItems = searchController.searchBar.text!.count > 0 ?
        self.items.filter({searchPredicate.evaluate(with: $0.name)}) : self.items
    }
    self.tableView.reloadData()
  }
  
  func showErrorAler(message: String) {
    let alert = UIAlertController(title: "Erro", message: message, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in }
    alert.addAction(okAction)
    self.present(alert, animated:true, completion: nil)
  }
  
  // MARK:-  CRUD Functions
  
  @objc func newItem(name: String, localizedName: String?, price: NSNumber?) {
    let newShoppingItem = ShoppingItem()
    newShoppingItem.name = name
    newShoppingItem.localizedName = localizedName
    newShoppingItem.price = price
    newShoppingItem.saveInBackground().continueOnSuccessWith(block: { (_) -> Any? in
      self.fetchData()
    })
  }
  
  @objc func removeItem(at row: Int) {
    self.items.remove(at: row)
    self.reloadData()
  }
  
  @objc func showNewItemDialog(itemName: String?) {
    let alert = UIAlertController(title: "Novo item", message: "Insira os dados do item:", preferredStyle: UIAlertController.Style.alert )
    
    let save = UIAlertAction(title: "Finalizar", style: .default) { (alertAction) in
      let nameTextField = alert.textFields![0] as UITextField
      let localizedNameTextField = alert.textFields![1] as UITextField
      let priceTextField = alert.textFields![2] as UITextField
      
      if let name = nameTextField.text {
        if name != "" {
          if self.nameAlreadyExists(name: name) {
            if let localizedName = localizedNameTextField.text, let price = priceTextField.text {
              self.newItem(name: name, localizedName: localizedName, price: NSNumber(value: Float(price) ?? 0.0))
            }
          } else {
            // error name already exists
            self.showErrorAler(message: "Nome já existe.")
          }
        } else {
          // error name missing
          self.showErrorAler(message: "Campo do nome vazio.")
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
      textField.placeholder = "Nome em inglês (opcional)"
    }
    alert.addTextField { (textField) in
      textField.placeholder = "Preço (opcional)"
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
    if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
      let shoppingItem = self.getItems()[indexPath.row]
      cell.textLabel?.text = shoppingItem.name
      cell.detailTextLabel?.text = "\(shoppingItem.price!)" // works but label is not visible
      cell.accessoryView = shoppingItem.isNeeded.boolValue ? UIImageView(image: UIImage(systemName: "cube.box")) : UIImageView(image: UIImage(systemName: "cube.box.fill"))
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    let shoppingItem = self.getItems()[indexPath.row]
    shoppingItem.isNeeded = NSNumber(value: !shoppingItem.isNeeded.boolValue)
    shoppingItem.saveInBackground().continueOnSuccessWith { (_) -> Any? in
      self.fetchData()
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let shoppingItem = self.getItems()[indexPath.row]
      shoppingItem.deleteInBackground { (success: Bool, error: Error?) in
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
