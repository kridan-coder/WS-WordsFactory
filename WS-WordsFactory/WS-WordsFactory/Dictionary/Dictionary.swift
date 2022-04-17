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
  init(word: String, phonetic: String, meaning: Meaning) {
    self.word = word
    self.phonetic = phonetic
    self.meaning = meaning
  }
  
  enum CodingKeys: String, CodingKey {
    case word, phonetic, meaning = "meanings"
  }
  
  let word: String
  let phonetic: String?
  let meaning: Meaning
  
  var realPhonetic: String {
    guard let phonetic = phonetic else {
      return ""
    }

    var phonetic2 = phonetic
    let firstIndex = phonetic2.firstIndex(of: "/")!
    phonetic2.replaceSubrange(firstIndex...firstIndex, with: "[")
    let secondIndex = phonetic2.firstIndex(of: "/")!
    phonetic2.replaceSubrange(secondIndex...secondIndex, with: "]")
    return phonetic2
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    word = try container.decode(String.self, forKey: .word)
    phonetic = try? container.decode(String.self, forKey: .phonetic)
    let meanings = try container.decode([Meaning].self, forKey: .meaning)
    meaning = meanings[0]
  }
  
  
}

struct Meaning: Codable {
  internal init(partOfSpeech: String, definitions: [Definition]) {
    self.partOfSpeech = partOfSpeech
    self.definitions = definitions
  }
  
  let partOfSpeech: String
  let definitions: [Definition]
}

struct Definition: Codable, Identifiable {
  internal init(definition: String, example: String?) {
    self.definition = definition
    self.example = example
  }
  let id = UUID()
  let definition: String
  let example: String?
}

class RealmResponse: Object, Identifiable {
  
  var response: Response? {
    guard let meaning = meaning else { return nil }
    
    var definitions = [Definition]()
    for el in meaning.definitions {
      definitions.append(Definition(definition: el.definition, example: el.example.isEmpty ? nil : el.example))
    }
    let m = Meaning(partOfSpeech: meaning.partOfSpeech, definitions: definitions)
    return Response(word: word, phonetic: phonetic, meaning: m)
  }
  override static func primaryKey() -> String? {
          return "word"
      }
  @objc dynamic var word = ""
  @objc dynamic var phonetic = ""
  @objc dynamic var meaning: RealmMeaning? = nil
}

class RealmMeaning: Object {
  @objc dynamic var partOfSpeech = ""
  var definitions = RealmSwift.List<RealmDefinition>()
}

class RealmDefinition: Object {
  @objc dynamic var definition = ""
  @objc dynamic var example = ""
}

final class DictionaryViewModel: ObservableObject {
  @Published var searchResult: Response? = nil
  @Published var isShowingAlert = false
  @Published var alertText = ""
  
  private var isInternetConnectionAvailable: Bool {
    NetworkReachabilityManager()?.isReachable ?? false
  }
  
  func getWord(_ word: String) {
    if !isInternetConnectionAvailable {
      alertText = "Интернета нет :(\nНо мы попробуем использовать сохранённую инфу"
      isShowingAlert = true
      
      let realm = try! Realm()
      let result = realm.objects(RealmResponse.self).first { $0.word == word.lowercased() }
      searchResult = result?.response
    } else {
      getResponse(for: word) { result in
        switch result {
        case .failure(let error):
          self.alertText = error.localizedDescription
          self.isShowingAlert = true
        case .success(let result):
          self.searchResult = result
        }
        
      }
    }
  }
  
  private func getResponse(for word: String, completion: @escaping (Result<Response, Error>) -> Void) {
    guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else { return }
    AF.request(url, method: .get).validate(statusCode: 200..<205).response { response in
      switch response.result {
      case .success(let data):
        let coverted = try! JSONDecoder().decode([Response].self, from: data!)
        let realm = try! Realm()
        try! realm.write {
        let realmObj = RealmResponse()
        
        let realmMaining = RealmMeaning()
        realmMaining.partOfSpeech = coverted[0].meaning.partOfSpeech
        for element in coverted[0].meaning.definitions {
          let definition = RealmDefinition()
          definition.definition = element.definition
          definition.example = element.example ?? ""
          realmMaining.definitions.append(definition)
        }
        
        
          realmObj.word = coverted[0].word.lowercased()
          realmObj.phonetic = coverted[0].phonetic ?? ""
          realmObj.meaning = realmMaining
          realm.add(realmObj, update: .all)
        }
        
        completion(.success(coverted[0]))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

struct Dictionary: View {
  @State var currentTab = 0
  @ObservedResults(RealmResponse.self) var responses
  @State var searchText = ""
  
  @StateObject var viewModel = DictionaryViewModel()
  
    var body: some View {
      VStack {

        
        if currentTab == 0 {
          HStack {
            TextField("Search anything...", text: $searchText)
              .font(.custom("Rubik-Regular", size: 16))
              .padding()
            Spacer()
            Button {
              viewModel.getWord(searchText)
            } label: {
              Image("SearchIcon").padding()
            }
            
          }
          
          .frame(height: 55)
          .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
          .padding()
          if viewModel.searchResult == nil {
            
            
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
          } else if let result = viewModel.searchResult {
            VStack(alignment: .leading, spacing: 14) {
              HStack {
                HStack(spacing: 16) {
                  Text(result.word.capitalized)
                    .font(.custom("Rubik-SemiBold", size: 18))
                  
                  Text(result.realPhonetic)
                    .font(.custom("Rubik-Regular", size: 14))
                    .foregroundColor(Color("Orange"))
                  
                  Image("Sound")
                  Spacer()
                }.padding(.horizontal)
              }
              HStack {
                Text("Part of speech:")
                  .font(.custom("Rubik-SemiBold", size: 16))
                
                Text(result.meaning.partOfSpeech.capitalized)
                  .font(.custom("Rubik-Regular", size: 14))
              }.padding(.horizontal)
              Text("Meanings:")
                .font(.custom("Rubik-SemiBold", size: 16)).padding(.horizontal)
              ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                  
                  ForEach(result.meaning.definitions) { definition in
                    VStack(alignment: .leading) {
                      HStack {
                        Text(definition.definition)
                          .lineLimit(nil)
                          .font(.custom("Rubik-Regular", size: 12))
                        Spacer()
                      }
                      
                      
                      
                      if let example = definition.example {
                        HStack(alignment: .top) {
                          Text("Example:")
                            .font(.custom("Rubik-Regular", size: 12))
                            .foregroundColor(Color("Blue"))
                          Text(example)
                            .font(.custom("Rubik-Regular", size: 12))
                        }
                        
                        .padding(.top, 8)
                      }
                      
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
                  }
                }.padding(.horizontal)
              }
              
            }
          }
        } else if currentTab == 1 {
          Text("Training")
        } else if currentTab == 2 {
          Text("Video")
        }
        Spacer()
          .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(title: Text("Внимание"), message: Text(viewModel.alertText))
          }
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
              .padding(.top, 7)
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
              .padding(.top, 7)
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
              .padding(.top, 7)
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
        .padding(.top, -15)
      }
      
      .ignoresSafeArea(edges: [.bottom])
    }
}

struct Dictionary_Previews: PreviewProvider {
    static var previews: some View {
        Dictionary()
    }
}
