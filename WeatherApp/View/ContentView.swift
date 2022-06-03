//
//  ContentView.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherVM = WeatherViewModel()
    var body: some View {
        NavigationView{
            CurrentWeahterForecast(weatherVM: weatherVM)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
