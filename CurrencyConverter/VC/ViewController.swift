//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Yongping Chen on 2020/05/26.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, CurrencyPickerDelegate {
    @IBAction func tapAddCurrency(_ sender: Any) {
        
    }
    let exchangeRate = [
        "USDJPY": 107.70504,
        "USDCNY": 7.1368,
        "USDEUR": 0.917688
    ]
    var currencies =  [
        "USD",
        "CNY",
        "JPY",
        "EUR"
    ]
    
    let allCurrencies = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTC","BTN","BWP","BYN","BYR","BZD","CAD","CDF","CHF","CLF","CLP","CNY","COP","CRC","CUC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","GBP","GEL","GGP","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","IMP","INR","IQD","IRR","ISK","JEP","JMD","JOD","JPY","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LTL","LVL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRO","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLL","SOS","SRD","STD","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VEF","VND","VUV","WST","XAF","XAG","XAU","XCD","XDR","XOF","XPF","YER","ZAR","ZMK","ZMW","ZWL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
}

