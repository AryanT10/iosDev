//
//  ViewController.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    let stockViewModel = StockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Set up the search button action
        searchButton.target = self
        searchButton.action = #selector(didTapSearchButton)

        // Fetch and load the most active stocks into the table view
        stockViewModel.fetchMostActiveStocks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch stocks: \(error.localizedDescription)")
                }
            }
        }
    }

    // Action when search button is tapped
    @objc func didTapSearchButton() {
        let searchVC = SearchViewController() // Assuming you have a separate view controller for searching
        searchVC.delegate = self
        let navController = UINavigationController(rootViewController: searchVC)
        present(navController, animated: true, completion: nil)
    }

    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockViewModel.numberOfStocks()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        cell.textLabel?.text = stockViewModel.formattedStockInfo(at: indexPath.row)
        return cell
    }
    
    // SearchViewControllerDelegate Method
    func didSearchForStock(with stockData: StockData) {
        // If you want to display the searched stock in the same table view:
        stockViewModel.mostActiveStocks = [stockData] // Replace existing data with the searched stock
        tableView.reloadData()
    }
}
