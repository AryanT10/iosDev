//
//  SearchViewController.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSearchForStock(with stockData: StockData)
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: SearchViewControllerDelegate?
    var searchResults = [StockData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Enter stock symbol"
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let symbol = searchBar.text, !symbol.isEmpty else { return }
        
        // Fetch stock data for the searched symbol
        StockService.shared.fetchStockData(for: symbol) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stockData):
                    self?.searchResults = [stockData] // Store the result in an array
                    self?.tableView.reloadData() // Reload the table view to show the data
                case .failure(let error):
                    print("Failed to fetch stock data: \(error.localizedDescription)")
                }
            }
        }
        
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let stock = searchResults[indexPath.row]
        cell.textLabel?.text = "\(stock.shortName ?? "N/A") - $\(stock.priceEpsCurrentYear ?? 0)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStock = searchResults[indexPath.row]
        delegate?.didSearchForStock(with: selectedStock)
        dismiss(animated: true, completion: nil)
    }
}
