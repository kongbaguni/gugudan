//
//  ViewController.swift
//  gugudan
//
//  Created by SeoChangyul on 2017. 2. 25..
//  Copyright © 2017년 SeoChangyul. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            var type:Question.QuestionType? = nil
            switch indexPath.row {
            case 0:
                type = .더하기
            case 1:
                type = .빼기
            case 2:
                type = .곱하기
            case 3:
                type = .나누기
            default:
                break
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "question") as! QuestionTableViewController
            vc.type = type
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        default:
            break
        }
    }

}

