//
//  Tweet.swift
//  Twitter
//
//  Created by Nordine Sayah on 27/09/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    
    var description: String {
        return "\(name): \(text)"
    }
}
