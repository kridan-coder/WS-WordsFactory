//
//  FirstPage.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI

struct FirstPage: View {
    var body: some View {
      VStack {
        Image("CoolKidsLongDistanceRelationship")
          .resizable()
          .scaledToFit()
          .padding()
        Text("Learn anytime and anywhere")
          .multilineTextAlignment(.center)
          .padding(.horizontal, 50)
          .font(.custom("Rubik-Medium", size: 22))
        Text("Quarantine is the perfect time to spend your day learning something new, from anywhere!")
          .multilineTextAlignment(.center)
          .padding(.top, 5)
          .padding(.horizontal, 30)
          .font(.custom("Rubik-Regular", size: 14))
          .foregroundColor(Color("InkGray"))

      }
      .padding()
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
