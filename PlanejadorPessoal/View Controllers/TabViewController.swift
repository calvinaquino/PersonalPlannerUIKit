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
    shoppingListViewController.tabBarItem = UITabBarItem(title: "Mercado", image: UIImage(systemName: "cart"), tag: 0)

    let financesPlannerViewController = UINavigationController(rootViewController: FinancesPlannerViewController())
    financesPlannerViewController.tabBarItem = UITabBarItem(title: "Finanças", image: UIImage(systemName: "dollarsign.circle"), tag: 1)

    let tabBarList = [shoppingListViewController, financesPlannerViewController]

    viewControllers = tabBarList
  }


}
