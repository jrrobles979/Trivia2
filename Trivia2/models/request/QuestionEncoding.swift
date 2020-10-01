//
//  QuestionEncoding.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 21/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation

enum QuestionEncoding{
    case urlLegacy, url3986, base64
    var stringValue: String {
        switch self {
        case .urlLegacy: return "urlLegacy"
        case .url3986: return "url3986"
        case .base64: return "base64"
        }}
    var labelValue: String {
        switch self {
        case .urlLegacy: return "Legacy URL Encoding"
        case .url3986: return "URL Encoding(RFC 3986)"
        case .base64: return "Base64 Encoding"
        }}
}
