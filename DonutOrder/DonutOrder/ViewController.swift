//
//  ViewController.swift
//  DonutOrder
//
//  Created by Aryan Tuwar on 2024-07-04.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var managerButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!

    var pickerViewHandler: PickerViewHandler!

    override func viewDidLoad() {
        super.viewDidLoad()

        let store = Store()
        pickerViewHandler = PickerViewHandler(products: store.donuts)
        pickerView.delegate = pickerViewHandler
        pickerView.dataSource = pickerViewHandler

        pickerViewHandler.updateLabel = { [weak self] text in
            self?.productLabel.text = text
        }

        pickerViewHandler.updateImage = { [weak self] imageName in
            self?.productImageView.image = UIImage(named: imageName)
        }

        pickerViewHandler.updateTotalPrice = { [weak self] text in
            self?.totalPriceLabel.text = text
        }

        pickerViewHandler.updateProductLabel()
    }

    @IBAction func buyButtonTapped(_ sender: UIButton) {
        if let product = pickerViewHandler.selectedProduct {
            let quantity = pickerViewHandler.selectedQuantity
            // Perform purchase logic here
            showAlert(title: "Success", message: "Purchased \(quantity) \(product.shortName)(s)")
            pickerView.reloadAllComponents()
        }
    }

    @IBAction func managerButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Manager Mode", message: "Enter passcode", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            if let passcode = alertController.textFields?.first?.text, passcode == "1234" {
                self?.performSegue(withIdentifier: "showManager", sender: self)
            } else {
                self?.showAlert(title: "Error", message: "Incorrect passcode")
            }
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
