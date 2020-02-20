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

protocol DoubleConvertible {
    var doubleValue: Double { get }
}

protocol StringConvertible {
    var stringValue: String { get }
    var stringCurrencyValue: String { get }
}

protocol IntConvertigle {
    var intValue: Int { get }
}

extension Double: NumberConvertible, StringConvertible {
    var stringValue: String {
        String(format: "%.0f", self)
    }
    
    var stringCurrencyValue: String {
        String(format: "%.2f", self)
    }
    
    var numberValue: NSNumber {
        NSNumber(value: self)
    }
}

extension NSNumber: StringConvertible {
    var stringValue: String {
        String(format: "%.0f", self.doubleValue)
    }
    
    var stringCurrencyValue: String {
        String(format: "%.2f", self.doubleValue)
    }
}

extension Int: NumberConvertible, StringConvertible {
    var numberValue: NSNumber {
        NSNumber(value: self)
    }
    
    var stringValue: String {
        "\(self)"
    }
    
    var stringCurrencyValue: String {
        String(format: "%.2f", self)
    }
}

extension String: NumberConvertible, DoubleConvertible, IntConvertigle {
    var numberValue: NSNumber {
        return NSNumber(value: Double(self) ?? 0)
    }
    
    var doubleValue: Double {
        return self.numberValue.doubleValue
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
}
