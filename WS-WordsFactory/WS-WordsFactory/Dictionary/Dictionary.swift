//
//  Dictionary.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI

struct Dictionary: View {
  @State var currentTab = 0
    var body: some View {
      VStack {
        if currentTab == 0 {
          Text("HHEHEHEHHEHEHHEHHHEHEH")
        } else if currentTab == 1 {
          Text("Training")
        } else if currentTab == 2 {
          Text("Video")
        }
        Spacer()
        VStack {
          
          HStack {
            Spacer()
            Button {
              currentTab = 0
            } label: {
              VStack {
                Image("Tab1")
                  .renderingMode(.template)
                  .foregroundColor(currentTab == 0 ? Color("Orange") : Color("InkGray") )
                
                Text("Dictionary")
                  .font(.custom("Rubik-Regular", size: 14))
                  .foregroundColor(currentTab == 0 ? Color("Orange") : Color("InkGray") )
              }
              .padding(.top)
              .frame(width: 80)
              
            }
            
            Spacer()
            Button {
              currentTab = 1
            } label: {
              VStack {
                Image("Tab2")
                  .renderingMode(.template)
                  .foregroundColor(currentTab == 1 ? Color("Orange") : Color("InkGray") )
                
                Text("Training")
                  .font(.custom("Rubik-Regular", size: 14))
                  .foregroundColor(currentTab == 1 ? Color("Orange") : Color("InkGray") )
              }
              .padding(.top)
              .frame(width: 80)
            }
            
            Spacer()
            Button {
              currentTab = 2
            } label: {
              VStack {
                Image("Tab3")
                  .renderingMode(.template)
                  .foregroundColor(currentTab == 2 ? Color("Orange") : Color("InkGray") )
                
                Text("Video")
                  .font(.custom("Rubik-Regular", size: 14))
                  .foregroundColor(currentTab == 2 ? Color("Orange") : Color("InkGray") )
              }
              .padding(.top)
              .frame(width: 80)
            }
            
            Spacer()
          }
          .padding()
          Spacer()
        }
        .frame(height: 100)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")).offset(y: 10))
        .clipShape(CornerRadiusShape(corners: [.topLeft, .topRight], radius: 16))
      }
      
      .ignoresSafeArea(edges: [.bottom])
    }
}

struct Dictionary_Previews: PreviewProvider {
    static var previews: some View {
        Dictionary()
    }
}
