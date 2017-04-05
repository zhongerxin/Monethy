//
//  PickerViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/2/9.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,PickerViewDelegate  {
    var delegate:RecordViewDelegate?
    var hideAccountIds = [Int]()
    var activeAccounts = realm.objects(Account.self).filter("isDelete = false")
    var hidenAccounts = realm.objects(Account.self).filter("isDelete = false AND isShow = false")
    
    @IBOutlet weak var accountsPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapedCancelButton(_ sender: Any) {
        delegate?.appearPickerView(sender: false)
    }
    @IBAction func tapedDoneButton(_ sender: Any) {
        let selectAccount = hidenAccounts[accountsPicker.selectedRow(inComponent: 0)]
        try! realm.write{
            selectAccount.isShow = true
        }
        delegate?.appearPickerView(sender: false)
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hidenAccounts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(hidenAccounts[row].name)
    }
    
    
    func reloadData() {
        accountsPicker.reloadComponent(0)
    }

}
protocol PickerViewDelegate {
    func reloadData()
}
