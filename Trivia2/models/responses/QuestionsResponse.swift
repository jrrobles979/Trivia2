//
//  QuestionsResponse.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 26/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

class QuestionsResponse:Codable{
    let category:String
    let type:String
    let difficulty:String
    let question:String
    let correct_answer:String
    let incorrect_answers:[String]
    
    
    enum CodingKeys: String, CodingKey {
        case category
        case type
        case difficulty
        case question
        case correct_answer
        case incorrect_answers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decodeBase64(forKey: .category, encoding: .utf8)
        self.type = try container.decodeBase64(forKey: .type, encoding: .utf8)
        self.difficulty = try container.decodeBase64(forKey: .difficulty, encoding: .utf8)
        self.question = try container.decodeBase64(forKey: .question, encoding: .utf8)
        self.correct_answer = try container.decodeBase64(forKey: .correct_answer, encoding: .utf8)
        self.incorrect_answers = try container.decodeBase64(forKey: .incorrect_answers, encoding: .utf8)
    }
    
}

extension KeyedDecodingContainer {
    func decodeBase64(forKey key: Key, encoding: String.Encoding) throws -> String {
        
        guard let string = try self.decode(String.self, forKey: key).decodeBase64(encoding: encoding) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self,
                                                   debugDescription: "Not a valid Base-64 representing UTF-8")
        }
        return string
    }
    
    func decodeBase64(forKey key: Key, encoding: String.Encoding) throws -> [String] {
        var arrContainer = try self.nestedUnkeyedContainer(forKey: key)
        var strings: [String] = []
        while !arrContainer.isAtEnd {
            guard let string = try arrContainer.decode(String.self).decodeBase64(encoding: encoding) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self,
                                                       debugDescription: "Not a valid Base-64 representing UTF-8")
            }
            strings.append(string)
        }
        
        return strings
    }
    
}

extension String {
    func decodeBase64(encoding: String.Encoding) -> String? {
        let base64Decoded = Data(base64Encoded: self)!
        let decodedString = String(data: base64Decoded, encoding:  .utf8)!
        return decodedString
    }
}





