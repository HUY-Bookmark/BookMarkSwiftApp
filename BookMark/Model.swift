//
//  Model.swift
//  BookMark
//
//  Created by Ellana Dairen on 22/11/2021.
//

import Foundation

struct TaskEntry: Codable  {
    let id: Int
    let title: String
}

struct Test: Codable {
    let response: String
    let id: Int
    let book_name: String
    let isbn13: String
    let isbn11: String
}
