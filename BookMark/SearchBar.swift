//
//  SearchBar.swift
//  BookMark
//
//  Created by ZHANG on 02/12/2021.
//

import SwiftUI

struct SearchBar: View {
    var body: some View {
        ZStack {
            Rectangle()
             .foregroundColor(Color("LightGray"))
            HStack {
             Image(systemName: "magnifyingglass")
             //TextField("Search ..", text: Text("Search"))
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
            }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
