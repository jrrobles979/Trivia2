//
//  ResultVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 29/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import AVFoundation

class ResultVC: UIViewController {
    
    
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var confettiOmage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblCorrectAnswers: UILabel!
    @IBOutlet weak var btnSeeYourAnswers: UIButton!
    @IBOutlet weak var btnPlayAgain: UIButton!
    var game:Game!    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let total_answered = game?.correct_questions ?? 0
        let total_questions = game?.total_questions ?? 0
        vwContainer.layer.cornerRadius = 10
        
        lblCorrectAnswers.text = "You got \(total_answered) of \(total_questions)"
        if ( game?.correct_questions == game?.total_questions ){
            confettiOmage.isHidden=false
            sadImage.isHidden=true
            lblMessage.text = "Congratulations!"
            lblResult.text = "You Won!"
            playMusic(file: Constants.winner, type: "mp3")
        } else {
            confettiOmage.isHidden=true
            sadImage.isHidden = false
            lblMessage.text = "I'm sorry!"
            lblResult.text = "You Lose"
            playMusic(file: Constants.loser, type: "mp3")
        }
        btnPlayAgain.roundedCorners(cornerRadius: 5, borderWidth: 0, borderColor: TriviaTheme.Colors.dodgerBlue.color.cgColor)
        btnSeeYourAnswers.roundedCorners(cornerRadius: 5, borderWidth: 0, borderColor: TriviaTheme.Colors.dodgerBlue.color.cgColor)
                
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    
    @IBAction func playAgaingTapped(_ sender: Any) {
        if let destinationViewController = navigationController?.viewControllers
            .filter(
                {$0 is MainVC})
            .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
    
    
    @IBAction func seeAnswersTapped(_ sender: Any) {
        let answersVC =  storyboard?.instantiateViewController(identifier: "gameSummaryVC") as!  GameSummaryVC
        answersVC.game = self.game
        self.navigationController?.showDetailViewController(answersVC, sender: self)
    }
    
    func playMusic(file:String, type:String){
        let path = Bundle.main.path(forResource: file, ofType: type)
        let url = URL(fileURLWithPath: path ?? "")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.setVolume(0.5, fadeDuration: 2)
            self.player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
