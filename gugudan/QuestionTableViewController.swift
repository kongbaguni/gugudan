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
    var type = Question.QuestionType.더하기
    
    var gameLog:GameLog? = nil

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gameLog == nil {
            startGame()
        }
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
        let q = Question()
        q.id = Int(q.start_date.timeIntervalSince1970)
        q.questionType = type

        switch type {
        case .곱하기, .더하기:
            q.number1 = Int.random(within: 1...9)
            q.number2 = Int.random(within: 1...9)
        case .빼기, .나누기:
            q.number1 = Int.random(within: 10...19)
            q.number2 = Int.random(within: 1...9)
        }
        
        try! Realm().write {
            try! Realm().add(q, update: true)
            GL.questionList.append(q)
            
        }
        self.tableView.reloadData()

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let GL = gameLog else {
            return 0
        }
        return GL.questionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let GL = gameLog else {
            return UITableViewCell()
        }
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
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
