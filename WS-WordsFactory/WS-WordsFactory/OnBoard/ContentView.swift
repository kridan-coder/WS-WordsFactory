//
//  ContentView.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 15.04.2022.
//

import SwiftUI
import Alamofire
import Kingfisher

struct ContentView: View {
  @State private var currentPage = 0
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button("Skip") {}
          .foregroundColor(Color("InkGray"))
          .font(.custom("Rubik-Medium", size: 16))
          .padding()
      }
      TabView(selection: $currentPage.animation()) {
        Text("1").tag(0)
        Text("2").tag(1)
        Text("3").tag(2)
      }
      .tabViewStyle(.page)
      .overlay(CustomIndexView(numberOfPages: 3, currentPage: currentPage), alignment: .bottom)
      .onChange(of: currentPage) { newValue in
        print(newValue)
      }
      if currentPage == 0 {
        Button {
          
        } label: {
          HStack {
            Spacer()
            Text("Next")
              .font(.custom("Rubik-Medium", size: 16))
              .foregroundColor(.white)
            Spacer()
          }
        }
        .frame(height: 60)
        .background(Color("Orange"))
        .cornerRadius(16)
        .padding(20)
        
      } else if currentPage == 1 {
        Button {
          
        } label: {
          HStack {
            Spacer()
            Text("Next")
              .font(.custom("Rubik-Medium", size: 16))
              .foregroundColor(.white)
            Spacer()
          }
        }
        .frame(height: 60)
        .background(Color("Orange"))
        .cornerRadius(16)
        .padding(20)
      } else if currentPage == 2 {
        Button {
          
        } label: {
          HStack {
            Spacer()
            Text("Let's start")
              .font(.custom("Rubik-Medium", size: 16))
              .foregroundColor(.white)
            Spacer()
          }
        }
        .frame(height: 60)
        .background(Color("Orange"))
        .cornerRadius(16)
        .padding(20)
      }
      
    }
    Text("Hello, world!")
      .font(.custom("Rubik-Bold", size: 24))
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
