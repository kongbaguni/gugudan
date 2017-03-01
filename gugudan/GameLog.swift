//
//  RecordModel.swift
//  gugudan
//
//  Created by SeoChangyul on 2017. 2. 25..
//  Copyright © 2017년 SeoChangyul. All rights reserved.
//

import Foundation
import RealmSwift

class GameLog: Object {
    dynamic var id:Int = 0
    dynamic var start_date:Date = Date()
    dynamic var end_date:Date = Date()
    
    let questionList = List<Question>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    func updateDate() {
        try! Realm().write {
            if let start = questionList.first?.start_date {
                start_date = start
            }
            if let end = questionList.last?.end_date {
                end_date = end
            }
        }
    }

    var time:TimeInterval {
        let time = end_date.timeIntervalSince1970 - start_date.timeIntervalSince1970
        if questionList.count < 10 {
            return Date().timeIntervalSince1970 - start_date.timeIntervalSince1970
        }
        return time
        
    }
    

}
