//
//  FormSelectionPickerViewController.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

class FormSelectionPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var options: [FieldOption] = []
    var pickerView = UIPickerView()
    
    convenience init(options: [FieldOption]) {
        self.init()
        self.options = options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .popover
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    
    
    //MARK - PickerView
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].name
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }

}
