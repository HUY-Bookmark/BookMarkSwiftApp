//
//  Requests.swift
//  BookMark
//
//  Created by Sarah Schlegel on 07/12/2021.
//

import Foundation


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
