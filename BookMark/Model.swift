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

struct Book: Codable {
    let response: String
    var id: Int
    let isbn13: String
    let isbn11: String
    let book_name: String
    let series_name: String
    let series_position: Int
    let genre: String
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
}
