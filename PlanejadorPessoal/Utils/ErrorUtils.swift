//
//  ErrorUtils.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class ErrorUtils {
  private static func getRootViewController() -> UIViewController? {
    UIApplication.shared.windows.first!.rootViewController
  }
  
  static func showErrorAler(message: String) {
    let alert = UIAlertController(title: "Erro", message: message, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in }
    alert.addAction(okAction)
    
    if let root = ErrorUtils.getRootViewController() {
      root.present(alert, animated:true, completion: nil)
    }
  }
}
