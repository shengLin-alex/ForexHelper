//
//  Model.swift
//  ios_FinalProject
//
//  Created by Yi-Jia Fu on 2019/6/9.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var time : String?
    var price : String?
    var transtype : String?
    var amount : String?
    var `return` : String?
    var pro : String?

    init(dict:[String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override init() {
        super.init()
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
