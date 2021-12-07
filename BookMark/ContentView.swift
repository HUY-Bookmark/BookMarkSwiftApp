import SwiftUI
import Combine

struct ContentView: View {
    
    @State var bookshelves = [Bookshelf]()
    @State var bookList = [Book]()
    
    @State private var selectedSorting = Sorting.author
    
    var usrData = UsrData(usr: 1, tok: "19208310")
    var bookDefault: Book = Book.init()
    
    //let host = "https://bookmark-bookshelf.herokuapp.com/api"
    let host = "http://localhost:8888/api"
    
    let bookshelfEndpoint = "/bookshelf"
    let bookIdEndpoint = "/book/id/"
    let bookSearchEndpoint = "/book/search/"
    let bookshelfSortEndpoint = "/bookshelf/"
  
    var body: some View {
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
                        Text("\(fullTitle(book: item))\n   by \(mergeAuthors(authorList: item.authors))")
                    }
                }
            }
        }
        .navigationTitle("Books")
        .onAppear(perform: loadBookshelf)
    }
    
  
    func loadBookshelf() {
        guard let url: URL = URL(string: self.host + self.bookshelfEndpoint)
        else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        do {
            urlRequest.httpBody = try JSONEncoder().encode(usrData)
            //print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                // check if response is okay
                
                guard let data = data else {
                    print("invalid response")
                    return
                }
                
                // convert JSON response into class model as an array
                do {
                    self.bookshelves = try JSONDecoder().decode([Bookshelf].self, from: data)
                    initBookshelf()
                } catch {
                    print("Bookshelf data load: " + error.localizedDescription)
                }
                
            }).resume()
        } catch {
            print("Bookshelf send request: " + error.localizedDescription)
        }
    }
    
    func initBookshelf () {
        var i = 1
        for bookshelf in self.bookshelves {
            for _ in bookshelf.shelves {
                bookList.append(Book.init())
            }
            
            for shelf in bookshelf.shelves {
                fetchBookData(bookid: shelf.book_id, id: i)
                i += 1
            }
            selectedSorting = selectSorting(str: bookshelf.sorting)
        }
    }
    
    func fetchBookData (bookid: String, id: Int) {
        guard let url: URL = URL(string: self.host + self.bookIdEndpoint + bookid)
        else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check if response is okay
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            do {
                var books = try JSONDecoder().decode([Book].self, from: data)
                books[0].id = id
                bookList[id - 1] = books[0]
            } catch {
                print("Book data load / \(bookid) :" + error.localizedDescription)
            }
            
        }).resume()
    }
    
    func fullTitle (book:Book) -> String {
        if (book.series_name != "" && book.series_position != 0) {
            return "\(book.series_name) #\(String(book.series_position)): \(book.book_name)"
        }
        if (book.series_name != "") {
            return "\(book.series_name): \(book.book_name)"
        }
        return book.book_name
    }
    
    func mergeAuthors (authorList: [String]) -> String {
        return authorList.joined(separator: ", ")
    }
    
    func selectSorting (str: String) -> Sorting {
        switch (str) {
            case "author": return Sorting.author
            case "title": return Sorting.title
            case "authord": return Sorting.authord
            case "titled": return Sorting.titled
            default: return Sorting.title
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
        guard let url: URL = URL(string: self.host + self.bookshelfSortEndpoint + sortingAsStr(s: selectedSorting))
        else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        do {
            print(url)
            urlRequest.httpBody = try JSONEncoder().encode(usrData)
            //print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                // check if response is okay
                
                guard let data = data else {
                    print("invalid response")
                    return
                }
                
                do {
                    let resorted = try JSONDecoder().decode([Bookshelf].self, from: data)
                    var i = 1
                    for bookshelf in resorted {
                        for shelf in bookshelf.shelves {
                            fetchBookData(bookid: shelf.book_id, id: i)
                            i += 1
                        }
                        selectedSorting = selectSorting(str: bookshelf.sorting)
                    }
                } catch {
                    print("Bookshelf data load: " + error.localizedDescription)
                }
            }).resume()
        } catch {
            print("Bookshelf send request: " + error.localizedDescription)
        }
    }
    
}

