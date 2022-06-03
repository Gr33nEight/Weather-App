//
//  CustomSearchBar.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI


/// Custom Search Bar  

struct CustomSearchBar: View {
    
    let placeholder: Text
    @Binding var text: String
    
    var body: some View {
        HStack{
            ZStack(alignment: .leading){
                if text.isEmpty{
                    placeholder
                        .lineLimit(1)
                        .foregroundColor(Color.black.opacity(0.2))
                }
                TextField("", text: $text)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
            }
            Spacer()
        }.padding()
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 5)
                        .fill(.blue)
                    Color.black.opacity(0.04)
                        .cornerRadius(20)
                        .frame(height: 50)
                }
            )
    }
}

