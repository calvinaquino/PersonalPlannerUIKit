//
//  CalendarManager.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/13/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import Foundation

class CalendarManager {
  var month: Int!
  var year: Int!
  
  init() {
    self.month = Calendar.current.component(.month, from: Date()) - 1 // keep it zero base
    self.year = Calendar.current.component(.year, from: Date())
  }
  
  func nextMonth() {
    if self.month + 1 > 11 {
      self.month = 0
      self.year = self.year + 1
    } else {
      self.month = self.month + 1
    }
  }
  
  func previousMonth() {
    if self.month - 1 < 0 {
      self.month = 11
      self.year = self.year - 1
    } else {
      self.month = self.month - 1
    }
  }
  
  func currentMonthAndYear() -> String {
    return DateFormatter().monthSymbols[self.month] + " \(self.year!)"
  }
}
