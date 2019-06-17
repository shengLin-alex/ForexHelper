//
//  Transaction.swift
//  ios_FinalProject
//
//  Created by sunny on 2019/6/11.
//  Copyright © 2019 sunny. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    var info: TransactionInfo
    var item: [TransactionData]
    var error: String?
}

struct TransactionInfo: Codable {
    var start: String
    var end: String
    var total: Int
    var amount: Double
    var acc: Double
    var `return`: Double
}

struct TransactionData: Codable {
    var time: String
    var price: Double
    var transType: String
    var amount: Double
    var `return`: Double
}
