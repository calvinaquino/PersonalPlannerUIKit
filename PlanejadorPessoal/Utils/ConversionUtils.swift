//
//  ConversionUtils.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/18/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation

protocol NumberConvertible {
  var numberValue: NSNumber { get }
}

protocol CurrencyConvertible {
  var currencyString: String { get }
}

extension Double: NumberConvertible, CurrencyConvertible {
  var currencyString: String {
    String(format: "%.2f", self)
  }
  
  var numberValue: NSNumber {
    NSNumber(value: self)
  }
}

extension NSNumber: CurrencyConvertible {
  var currencyString: String {
    String(format: "%.2f", self.doubleValue)
  }
}

extension Int: NumberConvertible, CurrencyConvertible {
  var numberValue: NSNumber {
    NSNumber(value: self)
  }
  
  var currencyString: String {
    String(format: "%.2f", self)
  }
}

extension String: NumberConvertible {
  var numberValue: NSNumber {
    return NSNumber(value: Double(self) ?? 0)
  }
}
