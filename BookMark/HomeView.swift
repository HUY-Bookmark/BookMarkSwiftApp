//
//  HomeView.swift
//  BookMark
//
//  Created by ZHANG on 02/12/2021.
//

import SwiftUI

struct HomeView: View {
    @State var selection: Int? = nil
    var body: some View {
        NavigationView {
            ZStack{
                Image("bookshelf_background")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color.white.opacity(0.4))
                    .ignoresSafeArea()
                VStack{
                    Text("WELCOME")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .font(.system(size:50, weight: .bold, design: .default))
                    HStack {
                        Text("TO")
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        .font(.system(size:40, weight: .bold, design: .default))
                        Text("BOOKMARK!")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .font(.system(size:55, weight: .bold, design: .default))
                    }
                    NavigationLink(destination: ContentView()) {
                        Text("Continue")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.indigo]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .font(.title)
                    }
                }
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
