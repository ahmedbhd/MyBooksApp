//
//  GenreSamples.swift
//  MyBooks
//
//  Created by Anypli M1 Air on 13/5/2024.
//

import Foundation

extension Genre {
    static var sampleGenres: [Genre] {
        [
            Genre(name: "Fiction", color: "00FF00"),
            Genre(name: "Non Fiction", color: "0000FF"),
            Genre(name: "Romance", color: "FF0000"),
            Genre(name: "Thriller", color: "000000")
        ]
    }
}
