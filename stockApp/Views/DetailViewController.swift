//
//  DetailViewController.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockChangeLabel: UILabel!
    @IBOutlet weak var rankSegmentedControl: UISegmentedControl!

    var stockData: StockData?

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let stockData = stockData {
//            stockSymbolLabel.text = stockData.symbol
//            stockPriceLabel.text = "$\(stockData.price)"
//            stockChangeLabel.text = "\(stockData.change) (\(stockData.changePercent)%)"
//            // Set rank if already ranked
//        }
//    }

    @IBAction func rankChanged(_ sender: UISegmentedControl) {
        // Handle ranking changes
    }
}
