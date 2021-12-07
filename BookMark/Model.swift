//
//  Model.swift
//  BookMark
//
//  Created by Sarah Schlegel on 22/11/2021.
//

import Foundation

struct UsrData: Codable {
    var usr: Int
    var tok: String
}

struct Book: Codable, Hashable {
    let response: String
    var id: Int
    let isbn13: String
    let isbn11: String
    let book_name: String
    let series_name: String
    let series_position: Int
    let genre: String
    let authors: [String]
    
    init() {
        response = ""
        id = 0
        isbn13 = ""
        isbn11 = ""
        book_name = ""
        series_name = ""
        series_position = 0
        genre = ""
        authors = [""]
    }
    
    func fullTitle () -> String {
        if (series_name != "" && series_position != 0) {
            return "\(series_name) #\(String(series_position)): \(book_name)"
        }
        if (series_name != "") {
            return "\(series_name): \(book_name)"
        }
        return book_name
    }
    
    func authorsString () -> String {
        return authors.joined(separator: ", ")
    }
}

struct Shelf: Codable {
    let book_id: String
    let shelf_number: Int
    let shelf_position: Int
}

struct Bookshelf: Codable {
    let id: Int
    let width: Int
    let height: Int
    let depth: Int
    let shelves_number: Int
    let sorting: String
    let shelves: [Shelf]
    
    func getSorting () -> Sorting {
        switch (sorting) {
            case "author": return Sorting.author
            case "title": return Sorting.title
            case "authord": return Sorting.authord
            case "titled": return Sorting.titled
            default: return Sorting.title
        }
    }
}

enum Sorting: String, CaseIterable, Identifiable {
    case title
    case titled
    case author
    case authord

    var id: String { self.rawValue }
}
