//
//  StockData.swift
//  stockApp
//
//  Created by Aryan Tuwar on 2024-08-16.
//

import Foundation

// The top-level response containing metadata and body
struct StockResponse: Codable {
    let meta: Meta
    let body: [StockData]
}

struct Meta: Codable {
    let version: String
    let status: Int
    let copywrite: String
    let count: Int
    let total: Int
    let page: Int
}

struct StockData: Codable {
    let  shortName: String
    let symbol: String
    let symbolType: Int
    let symbolName: String
    let hasOptions: String
    let lastPrice: String
    let priceChange: String
    let percentChange: String
    let optionsImpliedVolatilityRank1y: String
    let optionsTotalVolume: String
    let optionsPutVolumePercent: String
    let optionsCallVolumePercent: String
    let optionsPutCallVolumeRatio: String
    let tradeTime: String
    let symbolCode: String
}

