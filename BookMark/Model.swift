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

enum Sorting: String, CaseIterable, Identifiable {
    case title
    case titled
    case author
    case authord

    var id: String { self.rawValue }
}

func requestWithBody (method: String, urlStr: String, body: Data, dataProcess: @escaping (Data) -> Void) {
    
    
    guard let url: URL = URL(string: urlStr)
    else {
        print("invalid URL")
        return
    }
    
    var urlRequest: URLRequest = URLRequest(url: url)
    urlRequest.httpMethod = method
    do {
        urlRequest.httpBody = body
        //print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check if response is okay
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            dataProcess(data)
            
        }).resume()
    } catch {
        print("Error in \(method) to \(urlStr): \(error.localizedDescription)")
    }
}

func requestNoBody (method: String, urlStr: String, dataProcess: @escaping (Data, Int) -> Void, funcParam: Int) {
    
    
    guard let url: URL = URL(string: urlStr)
    else {
        print("invalid URL")
        return
    }
    
    var urlRequest: URLRequest = URLRequest(url: url)
    urlRequest.httpMethod = method
    do {
        //print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check if response is okay
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            dataProcess(data, funcParam)
            
        }).resume()
    } catch {
        print("Error in \(method) to \(urlStr): \(error.localizedDescription)")
    }
}
