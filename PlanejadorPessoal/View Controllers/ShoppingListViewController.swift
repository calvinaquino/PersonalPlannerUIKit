//
//  ShoppingListViewController.swift
//  Planejador Pessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/11/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITextFieldDelegate {
    
    var items: [ShoppingSection] = []
    var filteredItems: [ShoppingSection] = []
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    
    var sections: [ShoppingSection] {
        self.searchController.isActive ? self.filteredItems : self.items
    }
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.setupNavigationBar()
        self.setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: ItemCreatedNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.title = "Mercado"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItemTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openShoppingCategoriesOptions))
    }
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.register(ShoppingItemCell.self, forCellReuseIdentifier: ShoppingItemCell.Identifier)
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
        return self.items.hasItem(with: name)
    }
    
    func reloadData() {
        if searchController.isActive {
            self.filteredItems = searchController.searchBar.text!.count > 0 ?
                self.items.filterItems(with: searchController.searchBar.text!) : self.items
        }
        self.tableView.reloadData()
    }
    
    @objc func openShoppingCategoriesOptions() {
        let shoppingCategoriesViewController = ShoppingCategoriesViewController()
        self.navigationController?.pushViewController(shoppingCategoriesViewController, animated: true)
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
    
    @objc func newItemTapped() {
        self.openShoppingItemForm(forItem: nil)
    }
    
    @objc func openShoppingItemForm(forItem item: ShoppingItem? = nil) {
        let form = ItemFormViewController(item: item)
        self.present(form.withNavigation(), animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDeletate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ShoppingItemCell.Identifier, for: indexPath) as! ShoppingItemCell
        
        let shoppingItem = self.sections.item(at: indexPath)
        cell.textLabel?.text = shoppingItem.name
        cell.detailTextLabel?.text = shoppingItem.price?.currencyString
        cell.detailTextLabel?.textColor = .gray
        cell.isNeeded = shoppingItem.isNeeded!.boolValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let shoppingItem = self.sections.item(at: indexPath)
        self.openShoppingItemForm(forItem: shoppingItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let shoppingItem = self.sections.item(at: indexPath)
            shoppingItem.deleteInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if success {
                    self.fetchData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shoppingItem = self.sections.item(at: indexPath)
        let toggleItemTitle = shoppingItem.isNeeded.boolValue ? "Adquirido" : "Faltando"
        let toggleItem = UIContextualAction(style: .normal, title: toggleItemTitle) { (action, view, success) in
            shoppingItem.isNeeded = NSNumber(value: !shoppingItem.isNeeded.boolValue)
            shoppingItem.saveInBackground().continueOnSuccessWith { (_) -> Any? in
                DispatchQueue.main.async {
                    self.fetchData()
                }
            }
            success(true)
        }
        toggleItem.backgroundColor = .systemBlue
        let config = UISwipeActionsConfiguration(actions: [toggleItem])
        config.performsFirstActionWithFullSwipe = true
        return UISwipeActionsConfiguration(actions: [toggleItem])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let category = section.category
        return category.name!
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        self.reloadData()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            if searchText.count > 0 && self.filteredItems.count == 0 {
                let shoppingItem = ShoppingItem()
                shoppingItem.name = searchText
                self.openShoppingItemForm(forItem: shoppingItem)
            }
        }
        return true
    }
}
