//
//  RecommendedView.swift
//  BookMark
//
//  Created by Ellana Dairen on 07/12/2021.
//

import SwiftUI

struct RecommendedView: View {
    
    @State var recommendedList = [Book]()
    
    var body: some View {
        NavigationView {
            List(recommendedList, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text("\(item.fullTitle())\n   by \(item.authorsString())")
                }
            }
        }
        .navigationTitle("Recommended Books")
        .onAppear(perform: loadRecommended)
    }
    
    func loadRecommended () {
        requestNoBody(
            method: "GET",
            urlStr: apiHost + "/recommend",
            dataProcess: initRecommended,
            funcParam: 0)
    }
    
    func initRecommended (data: Data, id: Int) {
        do {
            let books = try JSONDecoder().decode([String].self, from: data)
            for _ in books {
                recommendedList.append(Book.init())
            }
            
            var i = 1
            for b in books {
                fetchBookData(bookISBN: b, id: i)
                i += 1
            }
        } catch {
            print("Recommended data load: " + error.localizedDescription)
        }
    }
    
    func fetchBookData (bookISBN: String, id: Int) {
        requestNoBody(
            method: "GET",
            urlStr: apiHost + bookIdEndpoint + bookISBN,
            dataProcess: loadBookItem,
            funcParam: id)
    }
    
    func loadBookItem (data: Data, id: Int) {
        do {
            var books = try JSONDecoder().decode([Book].self, from: data)
            books[0].id = id
            recommendedList[id - 1] = books[0]
        } catch {
            print("Book data load / \(id) :" + error.localizedDescription)
        }
    }
}
