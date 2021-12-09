//
//  RecommendedView.swift
//  BookMark
//
//  Created by Sarah Schlegel on 07/12/2021.
//

import SwiftUI


struct RecommendedView: View {
    
    @State var recommendedList = [Book]()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("< My Books")
        }
    }
    
    struct addBookData: Codable {
        var usr: Int
        var tok: String
        var book: String
    }
    
    var body: some View {
        VStack {
            Text("Recommended books")
                .bold()
            List(recommendedList, id: \.id) { item in
                VStack(alignment: .leading) {
                    HStack () {
                        Text("\(item.fullTitle())\n   by \(item.authorsString())")
                        Spacer(minLength: 5)
                        Button (action: {
                            if (addBookToShelf(isbn: item.isbn13) != 0) {
                                dismiss()
                            }
                        }) {
                            Text("+")
                            .frame(minWidth: 0, maxWidth: 10)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.indigo]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.system(size: 16, weight: .light, design: .default))
                        }
                    }
                }
            }
        }
//        .navigationTitle("Recommended Books")
        .onAppear(perform: fetchRecommended)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
    
    func fetchRecommended () {
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
    
    func addBookToShelf (isbn: String) -> Int {
        print(isbn)
        let addBook = addBookData(usr: usrData.usr, tok: usrData.tok, book: isbn)
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(addBook)
        } catch {
            print("Error")
            return 0
        }
        requestWithBody(
            method: "PUT",
            urlStr: apiHost + bookshelfEndpoint + "/book",
            body: jsonData,
            dataProcess: bookAdded)
        return 1
    }
    
    func bookAdded (data: Data) {
        print(data)
    }
}
