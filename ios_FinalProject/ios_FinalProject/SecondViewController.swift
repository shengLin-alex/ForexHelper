//
//  SecondViewController.swift
//  ios_FinalProject
//
//  Created by sunny on 2019/6/8.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {

    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //接收編輯頁面回傳的資訊
        let notificationName = Notification.Name("BackToPredictionPage")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
      // print()
       // setChart()
    }

    
    @IBOutlet weak var chartView: CandleStickChartView!
    
    @objc func getUpdateNoti(noti:Notification) {
        //接收編輯頁面回傳的資訊
        var InfoDetail = AddPredictionDetail()
        var itv: String
        InfoDetail = noti.userInfo!["PASS"] as! AddPredictionDetail
        
        print(InfoDetail.interval!)
        if InfoDetail.interval == "minute" {
            itv = "m1"
        } else if InfoDetail.interval == "hour" {
            itv = "h1"
        }else {
            itv = "d1"
        }
        APIHelp(itv: itv, start: InfoDetail.startTime!, end: InfoDetail.endTime!)
        
    }
    
    func APIHelp(itv: String, start: String, end: String) {
        let address = "http://140.124.42.169:10080/api/forex/prediction?crc_type=usdjpy&itv=\(itv)&label=u1_updown_rg_q1&start_time=\(start):00&end_time=\(end):00"
        if let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            //let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // 產生 URLSession
            let session = URLSession(configuration: .default)
            // 產生 task
            let task = session.dataTask(with: request) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    if let data = data {
                        let pred = try decoder.decode(Prediction.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.setChart(pred: pred)
                        }
                    }
                }catch {
                    print(error)
                }
            }
            // 開始下載
            task.resume()
        }
        
    }
    
    func setChart(pred: Prediction) {
        print(pred.item[1].time)
    }
}

