import SwiftUI

struct ContentView: View {
    
    @State var results = [Test]()
    
    var apiURL = "http://localhost:8888/api/book/search/Harry/ink";
  
    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(fullTitle(book: item))
            }
        }.onAppear(perform: loadData)
    }
    
  
    func loadData() {
        guard let url: URL = URL(string: self.apiURL)
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
            
            print(data)
            
            // convert JSON response into class model as an array
            do {
                self.results = try JSONDecoder().decode([Test].self, from: data)
            } catch {
                print("Catch " + error.localizedDescription)
            }
            
        }).resume()
    }
    
    func fullTitle (book:Test) -> String {
        return book.series_name + " #" + String(book.series_position) + ": " + book.book_name;
    }
    
}
