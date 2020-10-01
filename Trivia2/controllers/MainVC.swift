//
//  MainVC.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 18/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import UIKit
import CoreData
import RadioGroup
import GMStepper


class MainVC: UIViewController{
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var rgDifficulty: RadioGroup!
    @IBOutlet weak var questionsStepper: GMStepper!
    // @IBOutlet weak var svStatusContainer: UIStackView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblError: UILabel!
    
    // @IBOutlet weak var btnNewGame: UIButton!
    
    
    let categoryPickerView = UIPickerView()
    var selectectDifficulty:String = ""
    var selectedMaxQuestions:Int = 1
    var questionCategories:[CategoryResponse] = []
    var categorySelected:CategoryResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        fetchCategories()
    }
    
    func setup(){
        btnStart.roundedCorners(
            cornerRadius: Constants.buttons_corner_radius,
            borderWidth: Constants.buttons_border_width,
            borderColor: TriviaTheme.Colors.redPink.color.cgColor
        )
        vwContainer.layer.cornerRadius = 10
        categoryPickerView.delegate=self
        configStepper()
        configRadioGroup()
        configCategoryPicker()
        showActivityStatus(isActive: false, message: "")
        showError(error: "")
    }
    
    func showError(error:String){
        if error.count > 0 {
            lblError.text = error
            lblError.alpha = 1
        } else {
            lblError.isHidden = true
            lblError.alpha = 0
        }
    }
    
    
    
    
    func configCategoryPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(categoryTapped))
        toolbar.setItems([btnDone], animated: true)
        tfCategory.inputAccessoryView = toolbar
        tfCategory.inputView = categoryPickerView
    }
    
    
    func configRadioGroup(){
        rgDifficulty.spacing = 5
        rgDifficulty.itemSpacing = 5
        rgDifficulty.selectedIndex = 0;
        rgDifficulty.tintColor = TriviaTheme.Colors.slate.color
        rgDifficulty.titleColor = TriviaTheme.Colors.slate.color
        rgDifficulty.selectedColor = .black
        rgDifficulty.buttonSize = 16
        
        rgDifficulty.titleFont = TriviaTheme.font(font: TriviaTheme.RobotoFont.Medium, fontSize: 14)
        
        rgDifficulty.attributedTitles = [
            NSAttributedString(string: "All", attributes:nil),
            NSAttributedString(string: "Easy", attributes: nil),
            NSAttributedString(string: "Medium", attributes:nil),
            NSAttributedString(string: "Hard", attributes:nil)
        ]
        rgDifficulty.addTarget(self, action: #selector(optionSelected), for: .valueChanged)
    }
    
    func configStepper(){
        questionsStepper.labelFont = TriviaTheme.font(font: TriviaTheme.RobotoFont.Medium, fontSize: 14 )
        questionsStepper.buttonsFont = TriviaTheme.font(font: TriviaTheme.RobotoFont.Medium,  fontSize: 17)
        questionsStepper.buttonsTextColor = TriviaTheme.Colors.slate.color
        questionsStepper.labelTextColor = TriviaTheme.Colors.slate.color
        questionsStepper.labelBackgroundColor = TriviaTheme.Colors.paleGrey.color
        
        
        questionsStepper.minimumValue=1
        questionsStepper.maximumValue=20
    }
    
    
    
    func fetchCategories(){
        showActivityStatus(isActive: true, message: "Fetching categories")
        ApiManager.requestCategories(completion: handleCategoriesFetched(categories:error:))
    }
    
    
    
    @objc func optionSelected(){
    }
    
    
    func handleCategoriesFetched(categories:[CategoryResponse], error:Error?){
        guard let error = error else {
            self.showActivityStatus(isActive:false, message:"")
            questionCategories.removeAll()
            questionCategories.append(Constants.allCategories)
            questionCategories.append(contentsOf: categories)
            categorySelected = Constants.allCategories
            return
        }
        
        self.showActivityStatus(isActive: false, message: "")
        let alertAction = UIAlertAction( title : "Retry" ,
                                         style : .default) { action in
                                            self.fetchCategories()
        }
        
        self.displayAlert(title: "Categories not found", message: error.localizedDescription, handler:alertAction )
        self.btnStart.isEnabled = false
        
    }
    
    
    
    @objc func categoryTapped(){
        self.view.endEditing(true)
        
        guard let categorySelected = categorySelected else{
            return;
        }
        
        if(categorySelected.id != Constants.allCategories.id ){
            ApiManager.fetchCategoryQuestionsCount(categoryId: categorySelected.id, completion: handleCategoryQuestionsFetched(verifiedQuestions:error:)   )
        }
    }
    
    func handleCategoryQuestionsFetched(verifiedQuestions:Int, error:Error?){
        
        
        
    }
    
    
    @IBAction func btnStartTapped(_ sender: Any) {
        fetchQuestions()
    }
    
    func fetchQuestions(){
        showActivityStatus(isActive:true, message:"Fetching Questions...")
        guard let difficulty = GameDifficulty.init(rawValue: rgDifficulty.selectedIndex),
            let maxQuestions = Int(exactly:questionsStepper.value),
            let categoryId = categorySelected?.id
            else {
                showActivityStatus(isActive:false, message:"")
                showError(error: "Invalid configuration, check your game parameters")
                return
                
        }
        
        
        ApiManager.fetchQuestions(ammount: maxQuestions ,
                                  difficulty: difficulty ,
                                  category: categoryId,
                                  type: QuestionType.multiple.stringValue,  //default multiple
            completion: handleQuestionsFetched(responseCode:questions:error:))
        
    }
    
    func handleQuestionsFetched( responseCode:ResponseCodes, questions:[QuestionsResponse], error:Error?    ){
        switch responseCode {
        case ResponseCodes.success: do {
            self.createGame(questionsResponse: questions)
            break;
            }
            
        case ResponseCodes.token_empty: do {
            self.resetToken()
            return
            }
        case ResponseCodes.token_not_found: do {
            self.fetchApiToken()
            break
            }
        case ResponseCodes.invalid_param: do{
            displayAlert(title: "Network error", message: responseCode.description, handler: nil) //"Invalid parameter"
            showActivityStatus(isActive:false, message:"")
            break;
            }
        case ResponseCodes.no_results: do{
            displayAlert(title: "No questions found", message: responseCode.description, handler: nil)  //"No questions found for this game configuration, try to change difficulty or category."
            showActivityStatus(isActive:false, message:"")
            break
            }
        case ResponseCodes.undefined_error: do{
            displayAlert(title: "Error", message: responseCode.description, handler: nil)
            showActivityStatus(isActive:false, message:"")
            break;
            }
            
        }        
    }
    
    func fetchApiToken( ){
        ApiManager.requestToken(completion:handleTokenFetched(success:error:))
        showActivityStatus(isActive:true, message:"Fetching token")
    }
    
    func handleTokenFetched(success:Bool, error:Error?)
    {
        fetchQuestions()
    }
    
    func resetToken( ){
        ApiManager.resetApiToken(completion: handleTokenReseted(success:error:))
        showActivityStatus(isActive:true, message:"Resetting token")
    }
    
    func handleTokenReseted(success:Bool, error:Error?){
        fetchQuestions()
    }
    
    func createGame( questionsResponse:[QuestionsResponse] ){
        
        //Create a new model Game
        let game = DataController.shared.createGame(total_questions: questionsResponse.count)
        var questions:[Question] = []
        let created = DataController.shared.createQuestionsForGame(game: game, questionsResponse: questionsResponse)
        questions.append(contentsOf: created)
        
        let gameVC =  storyboard?.instantiateViewController(identifier: "gameVC") as!  GameVC
        gameVC.game = game
        gameVC.questions = questions
        
        showActivityStatus(isActive:false, message:"Game created")
        self.navigationController?.pushViewController(gameVC
            , animated: true)
        
    }
    
    
    func showActivityStatus(isActive:Bool, message:String){
        DispatchQueue.main.async {
            if(isActive){
                self.activityIndicator.startAnimating()
            }else{
                self.activityIndicator.stopAnimating()
            }
            
            self.activityIndicator.alpha = ( isActive ? 1 : 0  )
            self.lblStatus.alpha = ( isActive ? 1 : 0  )
            self.lblStatus.text = message
            
            self.btnStart.isEnabled = !isActive
            self.rgDifficulty.isEnabled = !isActive
            self.questionsStepper.isEnabled = !isActive
        }
        
    }
    
}

extension MainVC:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return questionCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return questionCategories[row].name // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = questionCategories[row]
        tfCategory.text = categorySelected?.name
    }
}






