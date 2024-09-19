//
//  StockService.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import Foundation

class StockService {
    static let shared = StockService()

    private let headers = [
        "x-rapidapi-key": "1aa6792dc9mshb45e3eef855eec2p1c9cdajsnc730fb2c236e",
        "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
    ]

    // Method to fetch most active stocks
    func fetchMostActiveStocks(completion: @escaping (Result<[StockData], Error>) -> Void) {
        let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/options/most-active?type=STOCKS"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            // Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let stockResponse = try decoder.decode(StockResponse.self, from: data)
                completion(.success(stockResponse.body))
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }

    // Method to fetch data for a specific stock symbol
    func fetchStockData(for symbol: String, completion: @escaping (Result<StockData, Error>) -> Void) {
        let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/stock/\(symbol)/quote"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decoder = JSONDecoder()
                let stockData = try decoder.decode(StockData.self, from: data)
                completion(.success(stockData))
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
