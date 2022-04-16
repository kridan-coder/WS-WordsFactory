//
//  CustomIndexView.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI

struct CustomIndexView: View {
   
  var numberOfPages: Int
  let currentPage: Int
    var body: some View {
      HStack(spacing: 10) {
        ForEach(0..<numberOfPages) { index in
          Capsule()
            .foregroundColor(index == currentPage ? Color("Blue") : Color("LightGray"))
            .frame(width: index == currentPage ? 20 : 6)
        }
      }
      .frame(height: 6)
    }
}

struct CustomIndexView_Previews: PreviewProvider {
    static var previews: some View {
      CustomIndexView(numberOfPages: 3, currentPage: 1)
        .frame(height: 6)
    }
}
