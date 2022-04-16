//
//  SignUp.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI

struct SignUp: View {
  @State var name = ""
  @State var email = ""
  @State var password = ""
  
  @State private var passwordIsHidden = true
  
  @State private var isSigningUp  = true
  var body: some View {
    if isSigningUp {
      ZStack {
        VStack {
          Image("CoolKidsStanding")
            .resizable()
            .scaledToFit()
          Text("Sign Up")
            .padding(.horizontal, 50)
            .font(.custom("Rubik-Medium", size: 22))
            .padding(.bottom, 8)
            .padding(.top, 6)
          Text("Create your account")
            .padding(.horizontal, 50)
            .font(.custom("Rubik-Regular", size: 14))
            .foregroundColor(Color("InkGray"))
          
          TextField("Name", text: $name)
            .frame(height: 18)
            .font(.custom("Rubik-Regular", size: 14))
            .foregroundColor(Color("InkGray"))
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
            .padding(.horizontal)
            .padding(.bottom, 10)
          
          TextField("E-mail", text: $email)
            .frame(height: 18)
            .font(.custom("Rubik-Regular", size: 14))
            .foregroundColor(Color("InkGray"))
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
            .padding(.horizontal)
            .padding(.bottom, 10)
          
          if passwordIsHidden {
            SecureField("Password", text: $password)
            
            .frame(height: 18)
              .font(.custom("Rubik-Regular", size: 14))
              .foregroundColor(Color("InkGray"))
            
              .overlay(Button {passwordIsHidden.toggle()} label: {Image("ClosedEye")}  , alignment: .trailing)
            
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
            
              .padding(.horizontal)
              .padding(.bottom, 10)
              
          } else {
            TextField("Password", text: $password)
              .frame(height: 18)
              .font(.custom("Rubik-Regular", size: 14))
              .foregroundColor(Color("InkGray"))
              .overlay(Button {passwordIsHidden.toggle()} label: {Image("OpenedEye")}  , alignment: .trailing)
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("InkGray")))
              .padding(.horizontal)
              .padding(.bottom, 10)
          }
          
          Button {
            withAnimation {
              isSigningUp.toggle()
            }
            
          } label: {
            HStack {
              Spacer()
              Text("Sign up")
                .font(.custom("Rubik-Medium", size: 16))
                .foregroundColor(.white)
              Spacer()
            }
          }
          .frame(height: 60)
          .background(Color("Orange"))
          .cornerRadius(16)
          .padding(.horizontal)
          
          
        }
      }
    } else {
       Dictionary()
    }
    
    
  }
}

struct SignUp_Previews: PreviewProvider {
  static var previews: some View {
    SignUp()
  }
}
