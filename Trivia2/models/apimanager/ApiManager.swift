//
//  ApiManager.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

class ApiManager{   
    static var sessionToken = ""
    
    
    
    enum Endpoints {
        static let base = "https://opentdb.com/"
        case requestSessionToken
        case resetSessionToken
        case getQuestions(ammount:Int, difficulty:GameDifficulty, category:Int, type:String  )
        case getCategories
        case getCategoryQuestionsCount(categoryId:Int)
        case getQuestionsCount
        
        var stringValue: String {
            switch self {
            case .requestSessionToken: return Endpoints.base+"api_token.php?command=request"
            case .resetSessionToken: return Endpoints.base+"api_token.php?command=reset&token=" + sessionToken
            case .getCategories: return Endpoints.base+"api_category.php"
            case .getQuestions(let ammount, let difficulty, let category, let type): return {
                // return "api.php?amount=10&category=13&difficulty=hard&type=boolean"
                var url =  Endpoints.base+"api.php?"
                //if(ammount < 10){
                //    url = url + "amount=1"
                //}else{
                    url = url + "amount=\(ammount)"
               // }
                if(difficulty != GameDifficulty.all ){
                    url = url + "&difficulty=\(difficulty)"
                }
                if(category > 0){
                    url = url + "&category=\(category)"
                }
                if(!type.isEmpty ){
                    url = url + "&type=\(type)"
                }
                
                url.append("&encode=\(QuestionEncoding.base64.stringValue)")
                
                
                return url
                }()
            case .getCategoryQuestionsCount(let categoryId): return Endpoints.base+"api_count.php?category=\(categoryId)"
            case .getQuestionsCount: return Endpoints.base+"api_count.php?category"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask
    {
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func requestToken(completion: @escaping (Bool, Error?) -> Void ){
        
        _ = taskForGETRequest(url: Endpoints.requestSessionToken.url, responseType: RequestTokenResponse.self) {
            response, error in
            if let response = response{
                
                if response.response_code == ResponseCodes.success.rawValue
                {
                    self.sessionToken = response.token
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    
    class func resetApiToken(completion: @escaping (Bool, Error?) -> Void ){
        
        _  = taskForGETRequest(url: Endpoints.resetSessionToken.url, responseType: RequestTokenResponse.self) {
            response, error in
            if let response = response{
                
                if response.response_code == ResponseCodes.success.rawValue
                {
                    self.sessionToken = response.token
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func requestCategories(  completion: @escaping ([CategoryResponse], Error?) -> Void   ){
        
        _ = taskForGETRequest(url: Endpoints.getCategories.url, responseType: CategoryResultsResponse.self) {
            response, error in
            if let response = response {
                completion ( response.trivia_categories, nil)
            } else {
                completion( [], error )
            }
        }
    }
    
    
    class func fetchQuestions( ammount:Int,
                                 difficulty:GameDifficulty,
                                 category:Int,
                                 type:String ,
                                 completion: @escaping( ResponseCodes,[QuestionsResponse],Error?) -> Void ) {
        print("url:\(Endpoints.getQuestions(ammount: ammount, difficulty: difficulty, category: category, type: type).url)")
        
        _ = taskForGETRequest(url: Endpoints.getQuestions(ammount: ammount, difficulty: difficulty, category: category, type: type).url, responseType: QuestionResultsResponse.self ){
            response, error in
            if let response = response {
                
                completion(ResponseCodes.init(rawValue:  response.response_code)! , response.results, nil )
                
            }else {
                completion(ResponseCodes.undefined_error, [], error)
            }
        }
    }
    
    class func fetchCategoryQuestionsCount(categoryId:Int, completion: @escaping(Int, Error? ) -> Void){
        _=taskForGETRequest(url: Endpoints.getCategoryQuestionsCount(categoryId:categoryId).url ,
                          responseType: CategoryQuestionResponse.self ){
                            response,error in
                            if let response = response {
                                completion(response.category_question_count.count, nil)
                            }  else {
                                completion(0, error)
                            }
        }
    }
    
    class func fetchQuestionsCount(completion: @escaping(Int,Error?) -> Void){
        _=taskForGETRequest(url: Endpoints.getQuestionsCount.url ,
                           responseType: QuestionGlobalCountResponse.self ){
                             response,error in
                             if let response = response {
                                
                                  completion(response.overall.total_num_of_verified_questions, nil)
                             }  else {
                                 completion(0,error)
                             }
         }
    }
    
    class func loadProfileImage(url:URL, completion:@escaping(Data?,Error?) -> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }.resume()
    }
    
    
}
