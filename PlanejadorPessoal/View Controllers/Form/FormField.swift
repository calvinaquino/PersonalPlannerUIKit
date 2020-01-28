//
//  FormField.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/27/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

enum FormFieldType {
    case TextInput
    case Selection
}

struct FieldOption {
    var id: String
    var name: String
}

struct FormField {
    var name: String
    var type: FormFieldType
    var value: String?
    var options: (() -> [FieldOption])?
    var didChange: ((String) -> Void)?
}
