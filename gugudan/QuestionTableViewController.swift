//
//  QuestionTableViewController.swift
//  gugudan
//
//  Created by SeoChangyul on 2017. 2. 25..
//  Copyright © 2017년 SeoChangyul. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RandomKit

class QuestionTableViewController: UITableViewController {
    var type:Question.QuestionType? = nil
    
    @IBOutlet var resultTimeLabel: UILabel!
    var gameLog:GameLog? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.addSubview(resultTimeLabel)
        if let bar = navigationController?.navigationBar {
            resultTimeLabel.frame.origin.y = bar.frame.origin.y + bar.frame.height
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gameLog == nil {
            startGame()
        }
        
        needTimeCheck = true
        self.timeCheck()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        needTimeCheck = false
        resultTimeLabel.removeFromSuperview()
    }
    func startGame() {
        gameLog = GameLog()
        gameLog?.id = Int(gameLog!.start_date.timeIntervalSince1970)
        try! Realm().write {
            try! Realm().add(gameLog!, update: true)
        }
        makeQuestion()
        
    }
    
    func makeQuestion() {
        guard let GL = gameLog else {
            return
        }
        if GL.questionList.count == 10 {
            self.tableView.reloadData()
            return
        }
        let q = Question()
        q.id = Int(q.start_date.timeIntervalSince1970)
        if let type = self.type {
            q.questionType = type
        }
        else {
            let types:[Question.QuestionType] = [
                Question.QuestionType.곱하기,
                Question.QuestionType.나누기,
                Question.QuestionType.더하기,
                Question.QuestionType.빼기
            ]
            q.questionType = types[Int.random(within:0...3)]
            
        }

        let a = Int.random(within: 2...9)
        let b = Int.random(within: 2...9)
        switch q.questionType {
        case .곱하기, .더하기:
            q.number1 = a
            q.number2 = b
        case .빼기:
            q.number1 = a + b
            q.number2 = b
        case .나누기:
            q.number1 = a * b
            q.number2 = b
        }
        
        try! Realm().write {
            try! Realm().add(q, update: true)
            GL.questionList.append(q)
            
        }
        self.tableView.reloadData()

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let GL = gameLog else {
            return 0
        }
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let GL = gameLog else {
            return 0
        }
        switch section {
        case 0:
            return GL.questionList.count
        default:
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let GL = gameLog else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            let q = GL.questionList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableViewCell
            cell.question = q
            cell.targetVc = self
            cell.textLabel?.attributedText = q.stringValue
            if q.isRightAnswer {
                cell.answerTextField.text = "\(q.answer)"
                cell.answerTextField.isEnabled = false
            }
            else {
                cell.answerTextField.isEnabled = true
                cell.answerTextField.text = nil
                if !cell.answerTextField.isFirstResponder {
                    cell.answerTextField.becomeFirstResponder()
                }
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "result", for: indexPath)
            cell.textLabel?.text = "\(Int(GL.time))"
            return cell
        }
    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    var needTimeCheck = true
    func timeCheck() {
        if needTimeCheck == false {
            return
        }
        guard let log = self.gameLog else {
            return
        }
        log.updateDate()
        resultTimeLabel.text = "\(Int(log.time))"
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCheck), userInfo: nil, repeats: false)
    }
    
}
