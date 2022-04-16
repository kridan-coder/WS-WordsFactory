//
//  Dictionary.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI
import Alamofire
import RealmSwift

struct Response: Codable {
  enum CodingKeys: String, CodingKey {
    case word, phonetic, meaning = "meanings"
  }
  
  let word: String
  let phonetic: String
  let meaning: Meaning
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    word = try container.decode(String.self, forKey: .word)
    phonetic = try container.decode(String.self, forKey: .phonetic)
    let meanings = try container.decode([Meaning].self, forKey: .meaning)
    meaning = meanings[0]
  }
}

struct Meaning: Codable {
  let partOfSpeech: String
  let definitions: [Definition]
}

struct Definition: Codable {
  let definition: String
  let example: String
}

class RealmResponse: Object, Identifiable {
  @objc dynamic var id = UUID()
  @objc dynamic var word = ""
  @objc dynamic var phonetic = ""
  let meaning: Meaning? = nil
}

class RealmMeaning: Object {
  @objc dynamic var partOfSpeech = ""
  let definitions = RealmSwift.List<RealmDefinition>()
}

class RealmDefinition: Object {
  @objc dynamic var definition = ""
  @objc dynamic var example = ""
}


struct Dictionary: View {
  @State var currentTab = 0
  @ObservedResults(RealmResponse.self) var responses
  @State var searchText = ""
  @State var searchResult: Response? = nil
  
    var body: some View {
      VStack {
        HStack {
          TextField("", text: $searchText)
          Spacer()
          
        }
        
        if currentTab == 0 {
          if searchText == "", searchResult == nil {
            VStack {
              Spacer()
              Image("CoolKidsPhone").resizable().scaledToFit().padding()
              Text("No word")
                .font(.custom("Rubik-Medium", size: 24))
                .padding(.bottom, 5)
              Text("Input something to find it in dictionary")
                .font(.custom("Rubik-Regular", size: 16))
                .foregroundColor(Color("InkGray"))
                Spacer()
            }
          }
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
