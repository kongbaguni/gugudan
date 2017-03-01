//
//  문제.swift
//  gugudan
//
//  Created by SeoChangyul on 2017. 2. 25..
//  Copyright © 2017년 SeoChangyul. All rights reserved.
//

import Foundation
import RealmSwift
class Question: Object {
    dynamic var id:Int = 0
    dynamic var start_date:Date = Date()
    dynamic var end_date:Date = Date()

    dynamic var number1:Int = 0
    dynamic var number2:Int = 0
    
    dynamic var _questionType:Int = 0
    
    enum QuestionType:Int {
        case 더하기 = 0
        case 빼기 = 1
        case 곱하기 = 2
        case 나누기 = 3
    }
    
    var questionType:QuestionType {
        set {
            _questionType = newValue.rawValue
        }
        get {
            if let type = QuestionType(rawValue: _questionType) {
                return type
            }
            return .곱하기
        }
    }
    
    
    dynamic var answer:Int = 0
    
    dynamic var isRightAnswer:Bool = false

    
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    var stringValue:NSAttributedString {
        var str = "*"
        switch self.questionType {
        case .곱하기:
            str = " * "
        case .빼기:
            str = " - "
        case .나누기:
            str = " / "
        case .더하기:
            str = " + "
        }
        let att = NSMutableAttributedString()

        att.append(NSAttributedString(string: " \(number1)", attributes:[
            NSFontAttributeName:UIFont.systemFont(ofSize:30)
            ]))
        att.append(NSAttributedString(string: str))
        att.append(NSAttributedString(string: "\(number2)", attributes:[
            NSFontAttributeName:UIFont.systemFont(ofSize:30)
            ]))
        att.append(NSAttributedString(string: " = "))
        
        
        
        return att
    }
    var time:TimeInterval {
        let time = end_date.timeIntervalSince1970 - start_date.timeIntervalSince1970
        if time == 0 {
            return Date().timeIntervalSince1970 - start_date.timeIntervalSince1970
        }
        return time
    }
    
    func check() {
        var an = 0
        switch self.questionType {
        case .더하기:
            an = number1 + number2
        case .빼기:
            an = number1 - number2
        case .곱하기:
            an = number1 * number2
        case .나누기:
            an = number1 / number2
        }
        isRightAnswer = answer == an
    }
    
}
