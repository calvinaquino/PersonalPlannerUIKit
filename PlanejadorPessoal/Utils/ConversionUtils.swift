//
//  ConversionUtils.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/18/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation

extension Double {
  var stringCurrency: String {
    String(format: "%.2f", self)
  }
  
  var numberValue: NSNumber {
    NSNumber(value: self)
  }
}

extension NSNumber {
  var stringCurrency: String {
    String(format: "%.2f", self.doubleValue)
  }
}
