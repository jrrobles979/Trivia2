//
//  CardAnswerdTableViewCell.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 02/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit

class CardAnswerdTableViewCell: UITableViewCell, CardCell {
    
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var lblQuestionIndex: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblFixedYourAnswer: UILabel!
    @IBOutlet weak var lblFixedCorrectAnswer: UILabel!
    
    
    @IBOutlet weak var lblSelectedAnswer: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(){
        cardContentView.layer.cornerRadius = 10
        cardContentView.layer.borderWidth = 2.0
        cardContentView.layer.borderColor = TriviaTheme.Colors.paleGrey.color.cgColor
        formatAnswerLabel(label: lblSelectedAnswer)
        formatAnswerLabel(label: lblAnswer)
        lblQuestion.adjustsFontSizeToFitWidth = true
        lblQuestion.minimumScaleFactor = 0.2
        lblFixedYourAnswer.isHidden = false
        lblSelectedAnswer.isHidden = false
    }
    
    
    func setQuestion(question:Question){
        setup()
        lblQuestionIndex.text = "Q"+String(question.question_index + 1)
        lblQuestion.text = question.question
        lblSelectedAnswer.text = (question.selected == "" || question.selected == nil ? " Ops!, you missed an answer" : " "+question.selected!)
        lblAnswer.text = " "+question.answer!
        if question.selected == question.answer {
            lblSelectedAnswer.isHidden = true
            lblFixedYourAnswer.isHidden = true
        }
        
    }
    
    func formatAnswerLabel(label:UILabel){
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        label.layer.borderColor = label.backgroundColor?.cgColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
       
        
    }
    
    /*  override func prepareForReuse() {
     super.prepareForReuse()
     lblQuestionIndex.text = nil
     lblQuestion.text = nil
     lblSelectedAnswer.text=nil
     lblAnswer.text = nil
     } */
    
}
