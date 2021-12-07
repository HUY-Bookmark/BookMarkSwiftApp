//
//  ModelEndpoints.swift
//  BookMark
//
//  Created by Ellana Dairen on 07/12/2021.
//

import Foundation


var usrData = UsrData(usr: 1, tok: "19208310")
var bookDefault: Book = Book.init()

//let apiHost = "https://bookmark-bookshelf.herokuapp.com/api"

let apiHost = "http://localhost:8888/api"
let bookshelfEndpoint = "/bookshelf"
let bookIdEndpoint = "/book/id/"
let bookSearchEndpoint = "/book/search/"
let bookshelfSortEndpoint = "/bookshelf/"
