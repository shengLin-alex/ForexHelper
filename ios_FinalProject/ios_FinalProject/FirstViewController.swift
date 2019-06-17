//
//  FirstViewController.swift
//  ios_FinalProject
//
//  Created by sunny on 2019/6/8.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit

let AKScreenWidth = UIScreen.main.bounds.size.width
let AKScreenHeight = UIScreen.main.bounds.size.height

class FirstViewController: UIViewController, AKExcelViewDelegate {

    //    var formatter: DateFormatter! = nil
    @IBOutlet weak var LabelView: UIView!
    @IBOutlet weak var OutputView: UIView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //接收編輯頁面回傳的資訊
        let notificationName = Notification.Name("BackToTransView")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
        
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //lableview
        let getLabelView : AKExcelView = AKExcelView.init(frame: CGRect.init(x: 0, y: 0, width: AKScreenWidth, height: AKScreenHeight))
        getLabelView.autoScrollToNearItem = true
        getLabelView.headerTitles = ["Start\ntime","End\ntime","Total","Accuracy","Amount","Return"]
        getLabelView.textMargin = 13
        getLabelView.leftFreezeColumn = 0
        getLabelView.properties = ["start","end","total","acc","amount","return"]
        getLabelView.delegate = self
        getLabelView.columnWidthSetting = [10:60]
        var arrLabel = [Label]()
     
        let label = Label()
        label.start = String.init("")
        label.end = String.init("")
        label.total = String.init("")
        label.acc = String.init("")
        label.amount = String.init("")
        label.return = String.init("")
        arrLabel.append(label)
        
        getLabelView.contentData = arrLabel
        LabelView.addSubview(getLabelView)
        getLabelView.reloadData()
        ///////////
        
        //outputview
        let excelView : AKExcelView = AKExcelView.init(frame: CGRect.init(x: 0, y: 0, width: AKScreenWidth, height: AKScreenHeight))
        // 自动滚到最近的一列
        excelView.autoScrollToNearItem = true
        // 设置表头
        excelView.headerTitles = ["Time","Price","Signal","Amount","Return"]
        // 设置间隙
        excelView.textMargin = 21
        // 设置左侧冻结栏数
        excelView.leftFreezeColumn = 0
        // 设置对应模型里面的属性  按顺序
        excelView.properties = ["time","price","transtype","amount","return"]
        excelView.delegate = self
        // 指定列 设置 指定宽度  [column:width,...]
        excelView.columnWidthSetting = [10:60]
        var arrM = [Model]()
        for _ in 0 ..< 1 {
            let model = Model()
            model.time = String.init("")
            model.price = String.init("")
            model.transtype = String.init("")
            model.amount = String.init("")
            model.return = String.init("")
            model.pro = ""
            arrM.append(model)
        }
        excelView.contentData = arrM
        OutputView.addSubview(excelView)
        excelView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue) {
        
    }
    
    @objc func getUpdateNoti(noti:Notification) {
        //接收編輯頁面回傳的資訊
        var InfoDetail = AddInfoDetail()
        var itv: String
        InfoDetail = noti.userInfo!["PASS"] as! AddInfoDetail
       // movieArray[movieDetail.order] = movieDetail
        if InfoDetail.interval == "minute" {
            itv = "m1"
        } else if InfoDetail.interval == "hour" {
            itv = "h1"
        }else {
            itv = "d1"
        }
        APIHelp(itv: itv, start: InfoDetail.startTime!, end: InfoDetail.endTime!, amount: InfoDetail.amount!)
        
    }
    
    func APIHelp(itv: String, start: String, end: String, amount: String) {
        let address = "http://140.124.42.169:10080/api/trade?crc_type=usdjpy&itv=\(itv)&label=u1_updown_rg_q1&start_time=\(start):00&end_time=\(end):00&basic_price=\(amount)"
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
                        let trans = try decoder.decode(Transaction.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.updateResult(trans: trans)
                            self.updatePrediction(trans: trans)
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
    
    func updateResult(trans: Transaction) {
        let getLabelView : AKExcelView = AKExcelView.init(frame: CGRect.init(x: 0, y: 0, width: AKScreenWidth, height: AKScreenHeight))
        getLabelView.autoScrollToNearItem = true
        getLabelView.headerTitles = ["Start\nTime","End\nTime","Total","Accuracy","Amount","Return"]
        getLabelView.textMargin = 4
        getLabelView.leftFreezeColumn = 0
        getLabelView.properties = ["start","end","total","acc","amount","return"]
        getLabelView.delegate = self
        getLabelView.columnWidthSetting = [10:60]
        var arrLabel = [Label]()
        let label = Label()
        label.start = trans.info.start.replacingOccurrences(of: " ", with: "\n")
        label.end = trans.info.end.replacingOccurrences(of: " ", with: "\n")
        label.total = String(trans.item.count)
        label.acc = String(trans.info.acc)
        label.amount = String(trans.info.amount)
        label.return = String(trans.info.return)
       
        arrLabel.append(label)

        getLabelView.contentData = arrLabel
        LabelView.addSubview(getLabelView)
        getLabelView.reloadData()

    }
    
    func updatePrediction(trans: Transaction) {
        //outputview
        let excelView : AKExcelView = AKExcelView.init(frame: CGRect.init(x: 0, y: 0, width: AKScreenWidth, height: AKScreenHeight))
        // 自動滚到最近的一列
        excelView.autoScrollToNearItem = true
        // 設置表頭
        excelView.headerTitles = ["Time","Price","Signal","Amount","Return"]
        // 設置間隙
        excelView.textMargin = 7
        // 設置左侧凍结檔數
        excelView.leftFreezeColumn = 0
        // 设置对应模型里面的属性  按顺序
        excelView.properties = ["time","price","transtype","amount","return"]
        excelView.delegate = self
        // 指定列 設置指定寬度  [column:width,...]
        excelView.columnWidthSetting = [10:60]
        var arrM = [Model]()
        for i in 0 ..< trans.item.count {
            let model = Model()
            model.time = trans.item[i].time
            model.price = String.init(trans.item[i].price)
            model.transtype = trans.item[i].transType
            model.amount = String.init(trans.item[i].amount)
            model.return = String.init(trans.item[i].return)
            model.pro = "others ..."
            arrM.append(model)
        }
        excelView.contentData = arrM
        OutputView.addSubview(excelView)
        excelView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
}

extension UIViewController {
    // 代理方法 點擊cell
    @objc func excelView(_ excelView: AKExcelView, didSelectItemAt indexPath: IndexPath) {
        print("section: \(indexPath.section)  -  item: \(indexPath.item)")
    }
    
    // 替换item View的代理方法
    @objc func excelView(_ excelView: AKExcelView, viewAt indexPath: IndexPath) -> UIView? {
        return nil
    }
    
}
