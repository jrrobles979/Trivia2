//
//  HistoryTVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 02/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import CoreData

class HistoryTVC: UITableViewController {
    var history:[Game] = []
    
    @IBOutlet weak var btnTrash: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        history.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        loadHistory()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        history.removeAll()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {      
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aGame = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryGameTableViewCell.defaultReuseIdentifier, for: indexPath) as! HistoryGameTableViewCell
        cell.setGame(game: aGame)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aGame = history[indexPath.row]
        let answersVC =  storyboard?.instantiateViewController(identifier: "gameSummaryVC") as!  GameSummaryVC
        answersVC.game = aGame
        self.navigationController?.showDetailViewController(answersVC, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteGame(indexPath: indexPath)
        default: () // Unsupported
        }
    }
    
    func deleteGame(indexPath:IndexPath){
        let aGameToDelete = self.history[indexPath.row]
        DataController.delete(aGameToDelete)
        self.history.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func loadHistory(){
        history.removeAll()
        // history.append(contentsOf:  DataController.shared.fetchGames() )
        let sortDescriptor = NSSortDescriptor(key: "created_date", ascending: false)
        let games = DataController.fetch(entity: Game.self, withSortDescriptors:[sortDescriptor] )
        if games != nil {
            history.append(contentsOf: games!)
        }
        tableView.reloadData()
    }
    
    @IBAction func clearAllTapped(_ sender: Any) {
        showDeleteAlert()
    }
    
    func deleteAllRecords(){
        
        DataController.reset(entity: Game.self)
        self.history.removeAll()
        loadHistory()
        
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "Delete game history?", message: "Are you sure you want to delete all your games history?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(alert: UIAlertAction!) in self.deleteAllRecords()} )
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}














