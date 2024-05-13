//
//  Quote.swift
//  MyBooks
//
//  Created by Anypli M1 Air on 10/5/2024.
//

import Foundation
import SwiftData

@Model
class Quote {
    var createdData: Date = Date.now
    var text: String
    var page: String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
