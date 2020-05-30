//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Yongping Chen on 2020/05/26.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, CurrencyPickerDelegate, CurrencyFetcherDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var fetcher: CurrencyFetdcher?
    
    var currencies =  [String]()
    var allCurrencies = [String]()
    var rates: [String: Double] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetcher = CurrencyFetdcher()
        self.fetcher?.delegate = self
        if let lastCurrencyUpdatedAt = UserDefaults.standard.object(forKey: "currencyRatesUpdatedAt") as? Date {
            let now = Date()
            if now.timeIntervalSince(lastCurrencyUpdatedAt) > 10 {
                self.fetcher?.fetchCurrency()
                self.activityIndicator.startAnimating()
            } else {
                self.allCurrencies = UserDefaults.standard.object(forKey: "currencies") as! [String]
                self.rates = UserDefaults.standard.object(forKey: "rates") as! [String: Double]
            }
        } else {
            self.fetcher?.fetchCurrency()
            self.activityIndicator.startAnimating()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CurrencyCellView
        cell.currencyLabel?.text = currencies[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCurrency" {
            let picker = segue.destination as! CurrencyPickerViewController
            picker.delegate = self
            picker.pickerData = allCurrencies.filter({ (c) -> Bool in
                return self.currencies.index(of: c) == nil
            })
        } else if segue.identifier == "changeCurrency" {
            let cell = (sender as! UIButton).superview?.superview as! CurrencyCellView
            let picker = segue.destination as! CurrencyPickerViewController
            picker.delegate = cell
            picker.pickerData = allCurrencies
            picker.selectedCurrency = cell.currencyLabel.text
        }
    }
    
    func selectedCurrency(_ currency: String) {
        self.currencies.append(currency)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.currencies.count - 1, section: 0)], with: .bottom)
        self.tableView.endUpdates()
    }
    
    func fetchedFailed(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchedCurrencies(currencies: [String], rates: [String: Double]) {
        self.allCurrencies = currencies
        UserDefaults.standard.set(Date(), forKey: "currencyRatesUpdatedAt")
        UserDefaults.standard.set(currencies, forKey: "currencies")
        UserDefaults.standard.set(rates, forKey: "rates")
        self.allCurrencies = currencies
        self.rates = rates
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }

    }
    
}

