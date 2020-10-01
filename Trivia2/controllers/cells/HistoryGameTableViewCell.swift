//
//  HistoryGameTableViewCell.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 02/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit

class HistoryGameTableViewCell: UITableViewCell, CardCell {

    @IBOutlet weak var lblGameDate: UILabel!
    @IBOutlet weak var lblGameDetail: UILabel!
    @IBOutlet weak var imgResult: UIImageView!
    
    let dateFormatter: DateFormatter = {
           let df = DateFormatter()
           df.dateStyle = .medium
           df.timeStyle = .medium
           return df
       }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setGame(game:Game){
        if ( game.correct_questions == game.total_questions )
        {
            imgResult.image = #imageLiteral(resourceName: "youwin")
        } else {
            imgResult.image = #imageLiteral(resourceName: "youlose")
        }
        if let created = game.created_date {
            lblGameDate.text = dateFormatter.string(from: created)
        }
        lblGameDetail.text = "You got \(game.correct_questions) of \(game.total_questions)"
    }

}
