//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Yongping Chen on 2020/05/26.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, CurrencyPickerDelegate, CurrencyFetcherDelegate, UITextFieldDelegate{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var fetcher: CurrencyFetdcher?
    
    var currenciesData: [String: Double] = [:]
//    var allCurrencies = [String]()
//    var rates: [String: Double] = [:]
    var currencies = [String]()
    var converter: CurrencyConverter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetcher = CurrencyFetdcher()
        self.fetcher?.delegate = self
        if let lastCurrencyUpdatedAt = UserDefaults.standard.object(forKey: "currencyRatesUpdatedAt") as? Date {
            let now = Date()
            // only request currency from server if last updates longer than 30 minutes
            if now.timeIntervalSince(lastCurrencyUpdatedAt) > 60*30 {
                self.fetcher?.fetchCurrency()
                self.activityIndicator.startAnimating()
            } else {
                self.converter = CurrencyConverter(
                    currencies: UserDefaults.standard.object(forKey: "currencies") as! [String],
                    rates: UserDefaults.standard.object(forKey: "rates") as! [String: Double]
                )
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
        let currency = currencies[indexPath.row]
        cell.currencyLabel?.text = currency
        if let value = currenciesData[currency] {
            cell.currencyValue?.text = self.converter!.currecnyToString(value: value)
        }
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
            picker.pickerData = self.converter!.currencies.filter({ (c) -> Bool in
                return self.currencies.index(of: c) == nil
            })
        }
    }
    
    func selectedCurrency(_ currency: String) {
        self.currencies.append(currency)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.currencies.count - 1, section: 0)], with: .bottom)
        // converter new add currency from 1st row
        if self.currencies.count > 1 {
            let oc = self.currencies[0]
            if let cv = self.currenciesData[oc] {
                self.currenciesData[currency] = self.converter!.convert(from: oc, value: cv, to: currency)
            }
        }
        self.tableView.endUpdates()
    }
    
    func fetchedFailed(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchedCurrencies(currencies: [String], rates: [String: Double]) {
        self.converter = CurrencyConverter(currencies: currencies, rates: rates)
        UserDefaults.standard.set(Date(), forKey: "currencyRatesUpdatedAt")
        UserDefaults.standard.set(currencies, forKey: "currencies")
        UserDefaults.standard.set(rates, forKey: "rates")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateCurrencyValues(currency: String, newValue: Double?) {
        if let value = newValue {
            self.currencies.filter{$0 != currency}.forEach { (newCurrency) in
                let cv = self.converter!.convert(from: currency, value: value, to: newCurrency)
                self.currenciesData[newCurrency] = cv
                DispatchQueue.main.async {
                    let cell = self.tableView.cellForRow(at: IndexPath(item: self.currencies.index(of: newCurrency)!, section: 0)) as! CurrencyCellView
                    cell.currencyValue.text = self.converter!.currecnyToString(value: cv)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.currencies.filter{$0 != currency}.forEach { (currency) in
                    let cell = self.tableView.cellForRow(at: IndexPath(item: self.currencies.index(of: currency)!, section: 0)) as! CurrencyCellView
                    cell.currencyValue.text = ""
                }

            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get currency
        let currencyCell = textField.superview?.superview as! CurrencyCellView
        let currency = currencyCell.currencyLabel.text!
        // get new value
        let currenctText = textField.text ?? ""
        let newText = String((currenctText as NSString).replacingCharacters(in: range, with: string))
        if newText == "" {
            updateCurrencyValues(currency: currency, newValue: nil)
            return true
        }
        if let cv = Double(newText) {
            self.currenciesData[currency] = cv
            updateCurrencyValues(currency: currency, newValue: cv)
            return true
        } else {
            return false
        }
    }
    
}

