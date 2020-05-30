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
    public var pickerData: [String] = [String]()
    public var selectedCurrency: String?
    var selectedRow: Int = 0

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
        if let sc = self.selectedCurrency, let idx = self.pickerData.index(of: sc) {
            self.selectedRow = idx
            self.picker.selectRow(self.selectedRow, inComponent: 0, animated: true)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
