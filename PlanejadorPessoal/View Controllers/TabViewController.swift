//
//  TabViewController.swift
//  Planejador Pessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/11/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let shoppingListViewController = UINavigationController(rootViewController: ShoppingListViewController())
    shoppingListViewController.tabBarItem = UITabBarItem(title: "Lista de compras", image: UIImage(named: "first"), tag: 0)

    let financesPlannerViewController = UINavigationController(rootViewController: FinancesPlannerViewController())
    financesPlannerViewController.tabBarItem = UITabBarItem(title: "Planejador financeiro", image: UIImage(named: "second"), tag: 1)

    let tabBarList = [shoppingListViewController, financesPlannerViewController]

    viewControllers = tabBarList
  }


}
