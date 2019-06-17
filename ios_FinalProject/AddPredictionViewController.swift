//
//  AddPredictionViewController.swift
//  ios_FinalProject
//
//  Created by sunny on 2019/6/13.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit

class AddPredictionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var StartTimeTextField: UITextField!
    @IBOutlet weak var EndTimeTextField: UITextField!
    @IBOutlet weak var IntervalTextField: UITextField!
    
    var noEmpty:Bool = false
    var formatter: DateFormatter! = nil
    let interval = ["minute", "hour", "day"]
    //產生PickerView
    var IntervalPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StartTimeTextField.delegate = self as UITextFieldDelegate
        EndTimeTextField.delegate = self as UITextFieldDelegate
        IntervalTextField.delegate = self as UITextFieldDelegate
        
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // 設定開始時間
        SetStartTime()
        // 設定結束時間
        SetEndTime()
        // 設定間隔時間
        SetInterval()
    }
    
    func Setoriginal(type: String) {
        // 設定時間
        let DatePicker = UIDatePicker()
        DatePicker.datePickerMode = .dateAndTime
        DatePicker.date = NSDate() as Date
        
        if type == "start" && StartTimeTextField.text!.isEmpty {
            StartTimeTextField.text = formatter.string(from: DatePicker.date)
        } else if type == "end" && EndTimeTextField.text!.isEmpty {
            EndTimeTextField.text = formatter.string(from: DatePicker.date)
        } else if type == "itv" && IntervalTextField.text!.isEmpty {
            IntervalTextField.text = "minute"
        }
    }
    
    func SetStartTime() {
        // 設定開始時間
        let StartDatePicker = UIDatePicker()
        StartDatePicker.datePickerMode = .dateAndTime
        StartDatePicker.date = NSDate() as Date
        // 設置 UIDatePicker 改變日期時會執行動作的方法
        StartDatePicker.addTarget(self,action: #selector(self.StartdatePickerChanged),for: .valueChanged)
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        StartTimeTextField.inputView = StartDatePicker
        StartTimeTextField.tag = 200
    }
    @objc func StartdatePickerChanged(datePicker:UIDatePicker) {
        // 依據元件的 tag 取得 UITextField
        let StartTextField = self.view?.viewWithTag(200) as? UITextField
        // 將 UITextField 的值更新為新的日期
        StartTextField?.text = formatter.string(from: datePicker.date)
    }
    
    func SetEndTime() {
        // 設定結束時間
        let EndDatePicker = UIDatePicker()
        EndDatePicker.datePickerMode = .dateAndTime
        EndDatePicker.date = NSDate() as Date
        // 設置 UIDatePicker 改變日期時會執行動作的方法
        EndDatePicker.addTarget(self,action: #selector(self.EnddatePickerChanged),for: .valueChanged)
        // 將 UITextField 原先鍵盤的視圖更換成 UIDatePicker
        EndTimeTextField.inputView = EndDatePicker
        EndTimeTextField.tag = 210
    }
    @objc func EnddatePickerChanged(datePicker:UIDatePicker) {
        // 依據元件的 tag 取得 UITextField
        let EndTextField = self.view?.viewWithTag(210) as? UITextField
        // 將 UITextField 的值更新為新的日期
        EndTextField?.text = formatter.string(from: datePicker.date)
    }
    
    func SetInterval() {
        //設定代理人和資料來源為viewController
        IntervalPicker.delegate = self
        IntervalPicker.dataSource = self
        //讓textfiled的輸入方式改為PickerView
        IntervalTextField.inputView = IntervalPicker
    }
    //有幾個區塊
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //裡面有幾列
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interval.count
    }
    //選擇到的那列要做的事
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        IntervalTextField.text = interval[row]
    }
    //設定每列PickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interval[row]
    }

    @IBAction func Back(_ sender: Any) {
        // 建立一個Yes/No提示框
        let alertController = UIAlertController(
            title: "離開新增資料頁面",
            message: "先不要？",
            preferredStyle: .alert)
        
        // 建立[離開]按鈕
        let okAction = UIAlertAction(
            title: "離開",
            style: .destructive,    // 以紅色顯示按鈕 提醒用戶
            handler: {
                (action: UIAlertAction!) -> Void in
                //回到前一頁
                self.dismiss(animated: true, completion: nil)
            }
        )
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        // 顯示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func Submit(_ sender: UIButton) {
        var addPred = AddPredictionDetail()
        
        if noEmpty {
            // 取畫面上的值
            addPred.startTime = StartTimeTextField.text
            addPred.endTime = EndTimeTextField.text
            addPred.interval = IntervalTextField.text
    
            //發送通知
            let notificationName = Notification.Name("BackToPredictionPage")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":addPred])
            //回到前一頁
            dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
        } else {
            print("error")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddPredictionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.StartTimeTextField {
            
            if StartTimeTextField.text!.isEmpty {
                Setoriginal(type: "start")
            }
                // else if 檢查輸入超過現在時間
            else {
                self.EndTimeTextField.becomeFirstResponder()
            }
            
        } else if textField == self.EndTimeTextField {
            if EndTimeTextField.text!.isEmpty {
                Setoriginal(type: "end")
            }
                // else if 檢查輸入超過開始時間
                // else if 檢查輸入超過現在時間
            else {
                self.IntervalTextField.becomeFirstResponder()
            }
            
//        } else if textField == self.IntervalTextField {
//            if IntervalTextField.text!.isEmpty {
//                Setoriginal(type: "itv")
//            }
//            else {
//                self.AmountTextField.becomeFirstResponder()
//            }
            
        } else {
            let thereWereErrors = checkForErrors()
            //      print(thereWereErrors)
            if !thereWereErrors
            {
                noEmpty = true
            }
            
        }
        return true
    }
    
    func checkForErrors() -> Bool {
        var errors = false
        let title = "Error"
        var message = ""
        if StartTimeTextField.text!.isEmpty {
            errors = true
            message += "Start time isn't empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.StartTimeTextField)
            self.StartTimeTextField.becomeFirstResponder()
            
        }
        else if EndTimeTextField.text!.isEmpty
        {
            errors = true
            message += "End time isn't empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.EndTimeTextField)
            self.EndTimeTextField.becomeFirstResponder()
        }
        else if IntervalTextField.text!.isEmpty
        {
            errors = true
            message += "Interval isn't empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.IntervalTextField)
            self.IntervalTextField.becomeFirstResponder()
        }
        //        else if !isValidEmail(emailField.text)
        //        {
        //            errors = true
        //            message += "Invalid Email Address"
        //            alertWithTitle(title, message: message, ViewController: self, toFocus:self.emailField)
        //        }
        
        //        else if count(passwordField.text.utf16)<8
        //        {
        //            errors = true
        //            message += "Password must be at least 8 characters"
        //            alertWithTitle(title, message: message, ViewController: self, toFocus:self.passwordField)
        //        }
        //
        return errors
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
}

