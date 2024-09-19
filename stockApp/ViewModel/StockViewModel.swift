//
//  StockViewModel.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import Foundation

class StockViewModel {

    // An array to hold the fetched stocks
    var mostActiveStocks: [StockData] = []

    // Fetch the most active stocks
    func fetchMostActiveStocks(completion: @escaping (Result<Void, Error>) -> Void) {
        StockService.shared.fetchMostActiveStocks { [weak self] result in
            switch result {
            case .success(let stocks):
                self?.mostActiveStocks = stocks
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetch data for a specific stock symbol
    func fetchStock(for symbol: String, completion: @escaping (Result<StockData, Error>) -> Void) {
        StockService.shared.fetchStockData(for: symbol) { result in
            switch result {
            case .success(let stockData):
                completion(.success(stockData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Helper method to format the stock data for display
    func formattedStockInfo(at index: Int) -> String {
        let stock = mostActiveStocks[index]
        return "\(stock.shortName ?? "N/A") - $\(stock.priceEpsCurrentYear ?? 0)"
    }

    // Get the count of most active stocks
    func numberOfStocks() -> Int {
        return mostActiveStocks.count
    }
}
