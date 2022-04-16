//
//  ThirdPage.swift
//  WS-WordsFactory
//

import SwiftUI

struct ThirdPage: View {
    var body: some View {
      VStack {
        Image("CoolKidsHighTech")
          .resizable()
          .scaledToFit()
          .padding()
        Text("Improve your skills")
          .padding(.horizontal, 50)
          .font(.custom("Rubik-Medium", size: 22))
        Text("Quarantine is the perfect time to spend your day learning something new, from anywhere!")
          .multilineTextAlignment(.center)
          .padding(.top, 5)
          .padding(.horizontal, 30)
          .font(.custom("Rubik-Regular", size: 14))
          .foregroundColor(Color("InkGray"))

      }
    }
}

struct ThirdPage_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPage()
    }
}
