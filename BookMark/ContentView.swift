import SwiftUI

struct ContentView: View {
    
    @State var bookshelves = [Bookshelf]()
    @State var bookList = [Book]()
    
    var usrData = UsrData(usr: 1, tok: "19208310")
    
    var host = "https://bookmark-bookshelf.herokuapp.com/api"
    
    var bookshelfEndpoint = "/bookshelf"
    var bookIdEndpoint = "/book/id/"
    var bookSearchEndpoint = "/book/search/"
  
    var body: some View {
        NavigationView{
            List(bookList, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text(fullTitle(book:item))
                    
                }
            }
            .onAppear(perform: loadBookshelf)
            .navigationTitle("Books")
        }
        
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
                    var i = 1
                    for bookshelf in self.bookshelves {
                        for shelf in bookshelf.shelves {
                            fetchBookData(bookid: shelf.book_id, id: i)
                            i += 1
                        }
                    }
                } catch {
                    print("Bookshelf data load: " + error.localizedDescription)
                }
                
            }).resume()
        } catch {
            print("Bookshelf send request: " + error.localizedDescription)
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
                bookList.append(books[0])
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
    
}
