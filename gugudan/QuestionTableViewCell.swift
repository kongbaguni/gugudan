//
//  QuestionTableViewCell.swift
//  gugudan
//
//  Created by SeoChangyul on 2017. 2. 26..
//  Copyright © 2017년 SeoChangyul. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class QuestionTableViewCell: UITableViewCell {
    var question:Question? = nil
    var targetVc:QuestionTableViewController? = nil
    @IBOutlet var accView:UIView!
    @IBOutlet var answerTextField: UITextField!
    @IBOutlet var timeLabel:UILabel!

    
    func timeCheck() {
        guard let question = self.question else {
            return
        }
        timeLabel.text = "\(Int(question.time))"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.accessoryView = accView
        answerTextField.addTarget(self, action: #selector(self.answerFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func answerFieldDidChange(_ sender:UITextField) {
        guard let question = self.question else {
            return
        }
        
        try! Realm().write {
            question.answer = NSString(string: answerTextField.text!).integerValue
            question.check()
            if question.isRightAnswer {
                question.end_date = Date()
            }
        }
        
        if question.isRightAnswer {
            targetVc?.makeQuestion()
        }
        
    }
    
    
}
