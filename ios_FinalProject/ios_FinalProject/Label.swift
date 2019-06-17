//
//  Label.swift
//  ios_FinalProject
//
//  Created by Yi-Jia Fu on 2019/6/12.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit

class Label: NSObject {
    
    var start : String?
    var end : String?
    var total : String?
    var acc : String?
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
