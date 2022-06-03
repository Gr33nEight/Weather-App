//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI

/// Models for the weather 

struct CurrentWeatherModel: Decodable {
    var current: WeatherCompsModel
}
struct DailyWeatherModel: Decodable {
    var daily: [DailyWeatherCompsModel]
}

struct Weather: Decodable {
    var icon: String
}
struct DayTemp: Decodable {
    var day: Double
}

struct WeatherCompsModel: Decodable {
    var temp: Double
    var pressure: Double
    var wind_speed: Double
    var weather: [Weather]
}

struct DailyWeatherCompsModel: Decodable {
    var temp: DayTemp
    var pressure: Double
    var wind_speed: Double
    var weather: [Weather]
}
