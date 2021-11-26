import SwiftUI

struct ContentView: View {
    
    @State var bookshelves = [Bookshelf]()
    @State var bookList = [Test]()
    
    var usrData = UsrData(usr: 1, tok: "19208310")
    
    var bookshelfApiURL = "http://localhost:8888/api/bookshelf"
    var bookIdApiURL = "http://localhost:8888/api/book/id/"
  
    var body: some View {
        List(bookList, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(fullTitle(book:item))
            }
        }.onAppear(perform: loadData)
    }
    
  
    func loadData() {
        guard let url: URL = URL(string: self.bookshelfApiURL)
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
                    print("Catch " + error.localizedDescription)
                }
                
            }).resume()
        } catch {
            print("Catch" + error.localizedDescription)
        }
    }
    
    func fetchBookData (bookid: String, id: Int) {
        guard let url: URL = URL(string: self.bookIdApiURL + bookid)
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
                var books = try JSONDecoder().decode([Test].self, from: data)
                books[0].id = id
                bookList.append(books[0])
            } catch {
                print("Catch " + error.localizedDescription)
            }
            
        }).resume()
    }
    
    func fullTitle (book:Test) -> String {
        return book.series_name + " #" + String(book.series_position)
        + ": " + book.book_name
    }
    
}
