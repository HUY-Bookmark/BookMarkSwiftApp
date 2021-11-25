//
//  Model.swift
//  BookMark
//
//  Created by Ellana Dairen on 22/11/2021.
//

import Foundation

struct Test: Codable {
    let response: String
    let id: Int
    let isbn13: String
    let isbn11: String
    let book_name: String
    let series_name: String
    let series_position: Int
    let genre: String
}
