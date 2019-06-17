//
//  Prediction.swift
//  ios_FinalProject
//
//  Created by sunny on 2019/6/11.
//  Copyright © 2019 sunny. All rights reserved.
//

import Foundation

struct Prediction: Codable {
    var item: [PredictionData]
    var error: String?
}

struct PredictionData: Codable {
    var time: String
    var crcType: String     // 幣種兌換代號(us to jpy)
    var pOpen: Double       // 開盤價格
    var pHigh: Double       // 最高價格
    var pLow: Double        // 最低價格
    var pCLose: Double      // 收盤價格
    var wma5: Double        // 加權移動平均線
    var wma20: Double
    var wma120: Double
    var stcFast93D: Double  // 隨機快步指數
    var stcSlow933D: Double // 隨機慢步指數
    var stcFast143D: Double
    var stcSlow1433D: Double
    var rsiSma5: Double      // 相對強弱指標
    var rsiSma9: Double
    var rsiSma14: Double
    var bollUpper: Double    // 布林通道上軌
    var bollLower: Double    // 布林通道下軌
    var macdDif: Double     // 指數平滑異同移動平均線 離差線
    var macdDem: Double     // 指數平滑異同移動平均線 訊號線
    var pred: Int           // 預測旗標 0 持平 1 漲 -1跌
}
