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
  @State private var isShowingOnBoard = true
  var body: some View {
    if isShowingOnBoard {
      VStack {
        HStack {
          Spacer()
          Button("Skip") {
            isShowingOnBoard = false
          }
          .foregroundColor(Color("InkGray"))
          .font(.custom("Rubik-Medium", size: 16))
          .padding()
        }
        TabView(selection: $currentPage.animation()) {
          FirstPage().tag(0)
          SecondPage().tag(1)
          ThirdPage().tag(2)
        }
        .tabViewStyle(.page)
        .overlay(CustomIndexView(numberOfPages: 3, currentPage: currentPage), alignment: .bottom)
        .onChange(of: currentPage) { newValue in
          print(newValue)
        }
        
        Button {
          if currentPage < 2 {
            withAnimation {
              currentPage += 1
            }
          } else {
            withAnimation {
              isShowingOnBoard = false
            }
          }
        } label: {
          HStack {
            Spacer()
            Text(currentPage == 2 ?  "Let's start"  : "Next")
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
    } else {
      SignUp()
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
