//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Yongping Chen on 2020/05/26.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let exchangeRate = [
        "USDJPY": 107.70504,
        "USDCNY": 7.1368,
        "USDEUR": 0.917688
    ]
    let currencies =  [
        "USD",
        "CNY",
        "JPY",
        "EUR"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = currencies[indexPath.row]
        return cell
    }


}

