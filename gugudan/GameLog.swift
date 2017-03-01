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
}
