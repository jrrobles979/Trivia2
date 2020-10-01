//
//  GameSummaryVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 02/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import CoreData

class GameSummaryVC: UIViewController, UITableViewDelegate {
    
    var game:Game!
    @IBOutlet weak var tableView: UITableView!
    var questions:[Question]=[]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self;
        tableView.dataSource=self
        questions.removeAll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        let predicate = NSPredicate(format: "game == %@", game)
        let sortDescriptor = NSSortDescriptor(key: "question_index", ascending: true)
        let fetchedQuestions = DataController.fetch(entity: Question.self, withSortDescriptors: [sortDescriptor], withPredicate: predicate)
        if fetchedQuestions != nil {
            questions.append(contentsOf: fetchedQuestions! )
        }
        tableView.reloadData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        questions.removeAll()
    }
    
  
}




extension GameSummaryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fetchedResultsController.sections?[0].numberOfObjects ?? 0
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aQuestion = questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CardAnswerdTableViewCell.defaultReuseIdentifier, for: indexPath) as! CardAnswerdTableViewCell
        cell.setQuestion(question: aQuestion)
        return cell
    }
    
}


