//
//  ShoppingCategoriesViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin De Aquino on 2020-02-01.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ShoppingCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate {
  
  var items: [ShoppingCategory] = []
  var filteredItems: [ShoppingCategory] = []
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
    self.title = "Categorias"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItemTapped))
  }
  
  func setupTableView() {
    self.tableView = UITableView()
    self.tableView.register(ShoppingCategoryCell.self, forCellReuseIdentifier: ShoppingCategoryCell.Identifier)
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
    DatabaseManager.fetchShoppingCategories { (shoppingCategories) in
      self.items = shoppingCategories
      if self.refreshControl.isRefreshing {
        self.refreshControl.endRefreshing()
      }
      self.reloadData()
    }
  }
  
  func nameAlreadyExists(name: String, whitelist: [String]?) -> Bool {
    if let whitelist = whitelist, whitelist.count > 0 {
      let whitelisted = self.items.filter { !whitelist.contains($0.name)}
      return whitelisted.filter{ $0.name == name }.first != nil
    }
    return self.items.filter{ $0.name == name }.first != nil
  }
  
  func getItems() -> [ShoppingCategory] {
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
  
  // MARK:-  CRUD Functions
  
  @objc func newItem(name: String) {
    let newShoppingCategory = ShoppingCategory()
    newShoppingCategory.name = name
    newShoppingCategory.saveInBackground().continueOnSuccessWith(block: { (_) -> Any? in
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
  
  @objc func showEditItemDialog(item: ShoppingCategory) {
    self.showItemDialog(itemName: nil, item: item)
  }
  
  @objc func showNewItemDialog(itemName: String? = nil) {
    self.showItemDialog(itemName: itemName, item: nil)
  }
  
  func showItemDialog(itemName: String? = nil, item: ShoppingCategory? = nil) {
    let isEditing = item != nil
    let title = isEditing ? "Editar item" : "Novo item"
    let alert = UIAlertController(title: title, message: "Insira os dados do item:", preferredStyle: UIAlertController.Style.alert )
    
    let save = UIAlertAction(title: "Finalizar", style: .default) { (alertAction) in
      let nameTextField = alert.textFields![0] as UITextField
      if let name = nameTextField.text, name != "" {
        let nameAlreadyExists = self.nameAlreadyExists(name: name, whitelist: isEditing ? [item!.name] : nil)
        if isEditing && !nameAlreadyExists, let item = item { // nameAlreadyExists needs to be checked but disregrd original name
          item.name = name
          item.saveInBackground { (_,_) in
            self.fetchData()
          }
        } else if !nameAlreadyExists {
          self.newItem(name: name)
        } else {
          ErrorUtils.showErrorAler(message: "Nome já existe.")
        }
      } else {
        ErrorUtils.showErrorAler(message: "Campo do nome vazio.")
      }
    }
    
    alert.addTextField { (textField) in
      textField.placeholder = "Nome"
      if let name = itemName {
        textField.text = name
      } else if isEditing {
        textField.text = item!.name
      }
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
    let cell = self.tableView.dequeueReusableCell(withIdentifier: ShoppingCategoryCell.Identifier, for: indexPath) as! ShoppingCategoryCell
    
    let ShoppingCategory = self.getItems()[indexPath.row]
    cell.textLabel?.text = ShoppingCategory.name
    cell.detailTextLabel?.textColor = .gray
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    let ShoppingCategory = self.getItems()[indexPath.row]
    self.showEditItemDialog(item: ShoppingCategory)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let budgetCtegory = self.getItems()[indexPath.row]
      budgetCtegory.deleteInBackground { (success: Bool, error: Error?) in
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
