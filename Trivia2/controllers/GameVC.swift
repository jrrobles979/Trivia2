//
//  GameVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 19/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import GaugeKit
import AVFoundation
import CoreData


class GameVC: UIViewController {
    
    @IBOutlet var answersOptions: [UIButton]!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var timerGauge: Gauge!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionIndexLabel: UILabel!
    
    
    var player: AVAudioPlayer?
    var countDown = 0
    var timer = Timer()
    var game:Game!
    var questions:[Question]=[]
    var currentQuestion:Question?
    var currentQuestionIndex:Int = 0
    
    var isLastQuestion:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in answersOptions {
            button.roundedCorners(cornerRadius: 5, borderWidth: 1, borderColor: TriviaTheme.Colors.paleGreyTwo.color.cgColor)
        }
        vwContainer.layer.cornerRadius = 10
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.2
        for button in answersOptions {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.2
            button.titleLabel?.numberOfLines = 1
        }
        
        startGame()
    }
    
    func startGame(){
        game.status = Int16( GameStatus.starting.rawValue )
        currentQuestionIndex = 0
        prepareForNextQuestion()
    }
    
    func prepareForNextQuestion(){
        if currentQuestionIndex == 0{
            questionLabel.text = "Get ready!"
        } else {
            questionLabel.text = Constants.next_questions_label.randomElement()
        }
        showQuestions(show: false)
        resetGauge(countDownValue: Constants.answer_time_countdown, startColor: TriviaTheme.Colors.greenblue.color, bgColor: TriviaTheme.Colors.greenbluelight.color)
        if currentQuestionIndex + 1 == questions.count {
            isLastQuestion = true
        }
        startTimer(completed: handleWaitTimeOut(timeout:) )
        playMusic(file:Constants.on_waiting_music, type: "mp3")
    }
    
    func showQuestions(show:Bool){
        questionIndexLabel.isHidden = !show
        answersOptions.forEach({
            $0.isHidden = !show
        })
    }
    
    func showNextQuestion(){
        if ( game.status == GameStatus.starting.rawValue ){
            game.status = Int16( GameStatus.playing.rawValue)
        }
        
        self.currentQuestion = self.questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion, var optionArray = currentQuestion.getOptionsAsStringArray()  else{
            print("Invalid question... exiting game")
            return
        }
        questionIndexLabel.text = "Question \(currentQuestionIndex + 1)"
        questionLabel.text = currentQuestion.question
        optionArray.shuffle()
        var index = 0
        for option in optionArray{
            let btn = answersOptions[index]
            btn.setTitle(option, for: .normal)
            index+=1
        }
        setUnselectFormatToOptions()
        if isLastQuestion {
            startTimer(completed: handleCompleteGame(timeout:))
        } else{
            currentQuestionIndex = currentQuestionIndex + 1
            startTimer(completed: handleQuesionTimeout(timeout:))
        }
        
        resetGauge(countDownValue: Constants.answer_time_countdown, startColor: TriviaTheme.Colors.dodgerBlue.color, bgColor: TriviaTheme.Colors.paleGrey.color)
        showQuestions(show:true)
        playMusic(file:Constants.on_game_music, type: "mp3")
    }
    
    func setUnselectFormatToOptions(){
        answersOptions.forEach({
            $0.backgroundColor = TriviaTheme.Colors.white.color
            $0.setTitleColor(  TriviaTheme.Colors.blueyGrey.color, for: .normal)
        })
    }
    
    
    @IBAction func answerSelected(_ sender: UIButton) {
        setUnselectFormatToOptions()
        sender.backgroundColor = TriviaTheme.Colors.dodgerBlue.color
        sender.setTitleColor(  TriviaTheme.Colors.white.color, for: .normal)
        currentQuestion?.selected = sender.titleLabel?.text
    }
    
    
    func getSelectedAnswer() -> Int{
        for (index,button) in answersOptions.enumerated(){
            if button.backgroundColor == TriviaTheme.Colors.dodgerBlue.color {
                return index
            }
        }
        return -1
    }
    
    func resetGauge( countDownValue:Int , startColor: UIColor, bgColor: UIColor  ){
        timerGauge.rate = 0
        countDown = countDownValue
        timerGauge.maxValue = CGFloat(countDown)
        timerGauge.startColor = startColor
        timerGauge.bgColor = bgColor
    }
    
    
    func startTimer(completed: @escaping(Bool)-> ()) {
        timer =  Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true) { (Timer) in                    
            if self.countDown > 0 {
                self.countDown -= 100
                let sec = Double(( self.countDown/1000 )).integerPart
                self.timerLabel.text = String( format: "%.0f",  sec  )
                self.timerGauge.rate = self.timerGauge.rate + 100
                if sec <= 3.0 {
                    self.player?.setVolume(0, fadeDuration: 3)
                }
            } else {
                Timer.invalidate()
                completed(true)
            }
        }
    }
    
    func handleWaitTimeOut(timeout:Bool){
        self.player?.stop()
        showNextQuestion()
    }
    
    func handleQuesionTimeout(timeout:Bool){
        self.player?.stop()
        saveGameAdvance()
        prepareForNextQuestion()
    }
    
    func handleCompleteGame(timeout:Bool){
        print("Game completed!")
        self.player?.stop()
        game.status = Int16( GameStatus.completed.rawValue )
        for question in self.questions{
            if question.answer == question.selected {
                game.correct_questions += 1
            }
        }
        saveGameAdvance()
        let resultVC =  storyboard?.instantiateViewController(identifier: "resultVC") as!  ResultVC
        resultVC.game = self.game
        self.navigationController?.pushViewController(resultVC
            , animated: true)
    }
    
    func saveGameAdvance(){
        DataController.shared.save()
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





