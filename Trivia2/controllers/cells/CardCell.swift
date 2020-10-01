//
//  CardCell.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 02/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation


protocol CardCell: class {
    /// A default reuse identifier for the cell class
    static var defaultReuseIdentifier: String { get }
}

extension CardCell {
    static var defaultReuseIdentifier: String {
        // Should return the class's name, without namespacing or mangling.
        // This works as of Swift 3.1.1, but might be fragile.
        return "\(self)"
    }
}
