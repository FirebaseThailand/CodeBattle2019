//
//  PaddingTextField.swift
//  iOSCodeBattle
//
//  Created by Phetrungnapha, Kittisak (Agoda) on 13/10/2562 BE.
//

import UIKit

final class PaddingTextField: UITextField {

    private let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
