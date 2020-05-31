//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by 陳勇平 on 2020/05/31.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import Foundation

class CurrencyConverter {
    public let currencies: [String]
    public let rates: [String: Double]
    
    init(currencies: [String], rates: [String: Double]) {
        self.currencies = currencies
        self.rates = rates
    }
    
    public func convert(from: String, value: Double, to: String) -> Double {
        let usdValue = value / rates[from]!
        return usdValue * rates[to]!
    }
    
    public func currecnyToString(value: Double) -> String {
        return String(format: "%.2f", value)
    }
}
