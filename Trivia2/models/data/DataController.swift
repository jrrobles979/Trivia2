//
//  DataController.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 18/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

import CoreData


class DataController{
    let persistentContainer:NSPersistentContainer
    static let shared = DataController(modelName: "Triviados")
    static var fetchedGames:[Game] = []
    static var fetchedQuestionsPerGame:[Question] = []
    static let gameEntityName = "Game"
    static let questionEntityName = "Question"
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var backgroundContext:NSManagedObjectContext!
    
    private init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts(){
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        
        
    }
    
    func load(completion: (() -> Void)? = nil ){
        persistentContainer.loadPersistentStores() {
            storeDescription, error in
            guard error == nil else {
                fatalError( error!.localizedDescription )
            }
            //  self.autoSaveViewContext(interval: Constants.autoSaveInterval)
            self.configureContexts()
            completion?()
        }
    }
    
    func save(){
        do {
            try DataController.shared.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    
}

//Auto saving
/*extension DataController{
 func autoSaveViewContext(interval: TimeInterval  ){
 
 print("autosaving...")
 guard interval > 0 else {
 print("Cannot set negative autosave interval")
 return
 }
 
 if viewContext.hasChanges{
 try? viewContext.save()
 }
 
 DispatchQueue.main.asyncAfter(deadline: .now() + interval){
 self.autoSaveViewContext(interval: interval)
 }
 }
 } */


extension DataController {
    
    func createGame(total_questions:Int)->Game?{
        let game = NSEntityDescription.insertNewObject(forEntityName: DataController.gameEntityName, into: viewContext) as! Game
        game.id = NSUUID().uuidString
        game.created_date = Date()
        game.total_questions = Int16(total_questions)
        game.correct_questions = 0
        game.status = Int16(GameStatus.created.rawValue)
        DataController.shared.save()
        return game
    }
    
    func updateGame(game:Game){
        if DataController.shared.viewContext.hasChanges {
            DataController.shared.save()
        }
    }
    

    
    func createQuestion(game:Game?, questionIndex:Int,  questionResponse:QuestionsResponse )->Question? {
        let question = NSEntityDescription.insertNewObject(forEntityName: DataController.questionEntityName, into: viewContext) as! Question
        question.game = game
        question.question_index = Int16(questionIndex)
        question.question =  questionResponse.question
        question.answer = questionResponse.correct_answer
        question.type =  questionResponse.type
        let difficulty =  GameDifficulty.byStringValue(name: questionResponse.difficulty)
        question.point_value = Int16(difficulty.gamePointValue)
        question.category = questionResponse.category
        
        var options:[String] = []
        
        for option in questionResponse.incorrect_answers {
            options.append( option )
        }
        options.append(questionResponse.correct_answer)
        question.setOptionsAsData(stringArray: options)
        DataController.shared.save()
        return question
    }
    
    func createQuestionsForGame(game:Game?, questionsResponse:[QuestionsResponse] )->[Question]{
        var questions:[Question] = []
        var questionIndex:Int = 0
        for questionResponse in questionsResponse {
            guard let q = createQuestion(game: game, questionIndex: questionIndex, questionResponse: questionResponse) else { return [] }
            questions.append(q)
            questionIndex+=1
        }
        return questions
    }
    
    func updateQuestion(question:Question ){
        if DataController.shared.viewContext.hasChanges {
            DataController.shared.save()
        }
    }
    
    
    static func fetch<T>(entity: T.Type,  withSortDescriptors:[NSSortDescriptor]? = nil, withPredicate predicate: NSPredicate? = nil) -> Array<T>? where T : NSManagedObject {
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        if  withSortDescriptors != nil && withSortDescriptors!.count > 0 {
            request.sortDescriptors = withSortDescriptors
        }
        request.predicate = predicate
        do {
            return try DataController.shared.viewContext.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func delete<T>(_ object: T) where T : NSManagedObject {
        DataController.shared.viewContext.delete(object)
        DataController.shared.save()        
    }
    
    static func reset<T>(entity: T.Type) where T : NSManagedObject {
        fetch(entity: entity.self)?.forEach{
            delete($0)
        }
    }
        
        
}
