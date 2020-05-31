//
//  CurrencyPicker.swift
//  CurrencyConverter
//
//  Created by 陳勇平 on 2020/05/30.
//  Copyright © 2020 Yongping Chen. All rights reserved.
//

import UIKit

protocol CurrencyPickerDelegate: AnyObject {
    func selectedCurrency(_ currency: String)
}

class CurrencyPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    public var pickerData: [String] = []
    public var selectedCurrency: String?

    var selectedRow: Int = 0
    var firstCom: [String] = []
    var secondCom: [[String]] = []
    weak var delegate: CurrencyPickerDelegate?
    
    @IBOutlet weak var picker: UIPickerView!    
    @IBAction func tapDone(_ sender: Any) {
        delegate?.selectedCurrency(pickerData[selectedRow])
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        for currency in self.pickerData {
            let firstLetter = String(currency.prefix(1))
            if self.firstCom.index(of: firstLetter) == nil {
                self.firstCom.append(firstLetter)
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.firstCom.count
        }
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.firstCom[row]
        }
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0) {
            let selectedLetter = self.firstCom[row]
            for (idx, currency) in self.pickerData.enumerated() {
                if (String(currency.prefix(1)) == selectedLetter) {
                    self.picker.selectRow(idx, inComponent: 1, animated: true)
                    break
                }
            }
            return
        }
        
        let selectedCurrency = self.pickerData[row]
        let firstLetter = String(selectedCurrency.prefix(1))
        let selectedFirstRow = self.picker.selectedRow(inComponent: 0)
        if self.firstCom[selectedFirstRow] != firstLetter {
            let idx = self.firstCom.index(of: firstLetter)!
            self.picker.selectRow(idx, inComponent: 0, animated: true)
        }
        selectedRow = row
    }
}
