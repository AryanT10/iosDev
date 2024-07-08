//
//  PickerView.swift
//  DonutOrder
//
//  Created by Aryan Tuwar on 2024-07-05.
//

import UIKit

class PickerViewHandler: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var products: [Donut]
    var selectedProduct: Donut?
    var selectedQuantity: Int = 1

    var updateLabel: ((String) -> Void)?
    var updateImage: ((String) -> Void)?
    var updateTotalPrice: ((String) -> Void)?

    init(products: [Donut]) {
        self.products = products
        self.selectedProduct = products.first
        super.init()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return products.count
        } else {
            return selectedProduct?.availabilityCount ?? 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let product = products[row]
            return "\(product.shortName) - $\(product.price)"
        } else {
            return "\(row + 1)"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedProduct = products[row]
            pickerView.reloadComponent(1)
        } else {
            selectedQuantity = row + 1
        }
        updateProductLabel()
    }

    func updateProductLabel() {
        if let product = selectedProduct {
            updateLabel?("\(product.title)")
            updateImage?(product.imageName)
            let totalPrice = product.price * Double(selectedQuantity)
            updateTotalPrice?(String(format: "$%.2f", totalPrice))
        } else {
            updateLabel?("Select a product")
            updateImage?("")
            updateTotalPrice?("Total: $0.00")
        }
    }
}
