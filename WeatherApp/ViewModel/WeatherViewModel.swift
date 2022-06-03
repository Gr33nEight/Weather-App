//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI

/// View Model of the whole weather

class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var lat = ""
    @Published var lon = ""
    @Published var currentWeather = WeatherCompsModel(temp: 0.0, pressure: 0, wind_speed: 0.0, weather: [Weather(icon: "")])
    @Published var daily = [DailyWeatherCompsModel]()
}
