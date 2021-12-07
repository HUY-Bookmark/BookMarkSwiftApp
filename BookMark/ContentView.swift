import SwiftUI
import Combine

struct ContentView: View {
    
    @State var bookshelves = [Bookshelf]()
    @State var bookList = [Book]()
    
    @State private var selectedSorting = Sorting.author
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    HStack {
                        Text("Ordered by")
                        Picker("Sorting", selection: $selectedSorting) {
                            Text("Author").tag(Sorting.author)
                            Text("Author (descending)").tag(Sorting.authord)
                            Text("Title").tag(Sorting.title)
                            Text("Title (descending)").tag(Sorting.titled)
                        }
                        .onReceive(Just(selectedSorting)) {
                            selectedSorting in resortBookshelf()
                        }

                    }
                    
                    List(bookList, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text("\(item.fullTitle())\n   by \(item.authorsString())")
                        }
                    }
                    NavigationLink(destination: RecommendedView()) {
                        Text("My recommended books")
                        .frame(minWidth: 0, maxWidth: 200)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.indigo]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .font(.system(size: 16, weight: .light, design: .default))
                    }
                    .opacity(0.5)
                }
            }
            .navigationTitle("Books")
            .onAppear(perform: loadBookshelf)
        }
        
    }
    
  
    func loadBookshelf () {
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(usrData)
        } catch {
            print("ERROR")
        }
        requestWithBody(
            method: "POST",
            urlStr: apiHost + bookshelfEndpoint,
            body: jsonData,
            dataProcess: loadBookshelfData)
    }
    
    func loadBookshelfData (data: Data) {
        do {
            self.bookshelves = try JSONDecoder().decode([Bookshelf].self, from: data)
            initBookList()
        } catch {
            print("Bookshelf data load: " + error.localizedDescription)
        }
    }
    
    func initBookList () {
        for bookshelf in self.bookshelves {
            for _ in bookshelf.shelves {
                bookList.append(Book.init())
            }
            
            var i = 1
            for shelf in bookshelf.shelves {
                fetchBookData(bookISBN: shelf.book_id, id: i)
                i += 1
            }
            selectedSorting = bookshelf.getSorting()
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
            bookList[id - 1] = books[0]
        } catch {
            print("Book data load / \(id) :" + error.localizedDescription)
        }
    }
    
    func sortingAsStr (s: Sorting) -> String{
        switch (s) {
            case Sorting.title: return "title"
            case Sorting.titled: return "titled"
            case Sorting.author: return "author"
            case Sorting.authord: return "authord"
        }
    }
    
    func resortBookshelf () {
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(usrData)
        } catch {
            print("ERROR")
        }
        
        requestWithBody(
            method: "PATCH",
            urlStr: apiHost + bookshelfSortEndpoint + sortingAsStr(s: selectedSorting),
            body: jsonData,
            dataProcess: updateBookList)
    }
    
    func updateBookList (data: Data) {
        do {
            let resorted = try JSONDecoder().decode([Bookshelf].self, from: data)
            var i = 1
            for bookshelf in resorted {
                for shelf in bookshelf.shelves {
                    fetchBookData(bookISBN: shelf.book_id, id: i)
                    i += 1
                }
                selectedSorting = bookshelf.getSorting()
            }
        } catch {
            print("Bookshelf data load: " + error.localizedDescription)
        }
    }
    
    func loadRecommended () {
        requestNoBody(
            method: "GET",
            urlStr: apiHost + "/recommend",
            dataProcess: initRecommend,
            funcParam: 0)
    }
    
    func initRecommend (data: Data, _: Int) {
        do {
            let isbns = try JSONDecoder().decode([String].self, from: data)
            for isbn in isbns {
                print(isbn)
            }
        } catch {
            print("Recommended list data load: " + error.localizedDescription)
        }
    }
    
}

