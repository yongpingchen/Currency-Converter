//
//  CurrencyFetcher.swift
//  CurrencyConverter
//
//  Created by 陳勇平 on 2020/05/30.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case `internal`, `httpError`, `serverError`, `parseError`
}

protocol CurrencyFetcherDelegate: AnyObject {
    func fetchedCurrencies(currencies: [String], rates: [String: Double])
    func fetchedFailed(error: Error)
}

class CurrencyFetdcher {
    weak var delegate: CurrencyFetcherDelegate?
    
    func fetchCurrency() {
        let Url = String(format: "http://apilayer.net/api/live?access_key=%@", arguments: ["20662e7888ed05d53e7282d54b7b3137"])
        guard let serviceUrl = URL(string: Url) else {
            delegate?.fetchedFailed(error: FetchError.internal)
            return
        }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    self.delegate?.fetchedFailed(error: FetchError.httpError)
                    return
                }
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let _ = json["success"] as? Bool {
                        guard let quotes = json["quotes"] as? [String: Double] else {
                            self.delegate?.fetchedFailed(error: FetchError.parseError)
                            return
                        }
                        var currencies = [String]()
                        var rates: [String: Double] = [:]
                        for (key, rate) in quotes {
                            let c = String(key.suffix(3))
                            rates[c] = rate
                            currencies.append(c)
                        }
                        self.delegate?.fetchedCurrencies(currencies: currencies.sorted(), rates: rates)
                        return
                    } else {
                        self.delegate?.fetchedFailed(error: FetchError.serverError)
                        return
                    }
                } catch {
                    self.delegate?.fetchedFailed(error: FetchError.parseError)
                    return
                }
            }
        }.resume()
    }
}
