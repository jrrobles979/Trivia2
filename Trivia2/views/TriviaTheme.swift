//
//  TriviaTheme.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 19/08/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
import UIKit



class TriviaTheme{
    enum Colors {
        case white
        case butterscotch
        case dodgerBlue
        case paleGreyTwo
        case blueBlue
        case cobaltTwo
        case slate
        case blueyGrey
        case veryLightBlue
        case redPink
        case redPinkLight
        case paleGrey
        case cobalt
        case darkBlueGrey
        case silver
        case greenblue
        case greenbluelight
        
        
        var stringValue:String{
            switch self {
                
            case .white: return"#ffffffff"
            case .butterscotch: return"#ffb844ff"
            case .dodgerBlue: return"#4C84FFff"
            case .paleGreyTwo: return"#dde1ebff"
            case .blueBlue: return"#295fd3ff"
            case .cobaltTwo: return"#1a439bff"
            case .slate: return"#5e657eff"
            case .blueyGrey: return"#8d93a9ff"
            case .veryLightBlue: return"#e7efffff"
            case .redPink: return"#f82867ff"
            case .redPinkLight: return "#f7a1bbff"
            case .paleGrey: return"#eaedf5ff"
            case .cobalt: return"#234593ff"
            case .darkBlueGrey: return"#162038ff"
            case .silver: return "#bfc5d0ff"
            case .greenblue: return "#21d39bff"
            case .greenbluelight: return "#a1d1c2ff"
                
            }
            
        }
        var color: UIColor {
            guard let color = UIColor(hex: stringValue) else{
                
                return UIColor.black
            }
            return color;
        }
        
    }
    
    
    
    enum RobotoFont {
        static let base = "Roboto-"
        case ThinItalic
        case Thin
        case Regular
        case BlackItalic
        case Light
        case LightItalic
        case Medium
        case MediumItalic
        case Bold
        case BoldItalic
        case Italic
        case Black
        
        var StringValue:String {
            switch self {
            case .ThinItalic: return RobotoFont.base+"ThinItalic"
            case .Thin: return RobotoFont.base+"Thin"
            case .Regular: return RobotoFont.base+"Regular"
            case .BlackItalic: return RobotoFont.base+"BlackItalic"
            case .Light: return RobotoFont.base+"Light"
            case .LightItalic: return RobotoFont.base+"LightItalic"
            case .Medium: return RobotoFont.base+"Medium"
            case .MediumItalic: return RobotoFont.base+"MediumItalic"
            case .Bold: return RobotoFont.base+"Bold"
            case .BoldItalic: return RobotoFont.base+"BoldItalic"
            case .Italic: return RobotoFont.base+"Italic"
            case .Black: return RobotoFont.base+"Black"
                
            }
        }
    }
    
    static func font( font: RobotoFont , fontSize: Float ) -> UIFont{
        return UIFont( name:font.StringValue, size: CGFloat(fontSize) )!
    }
}


