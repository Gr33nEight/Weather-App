//
//  DailyWeatherForecast.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI

struct DailyWeatherForecast: View {
    @ObservedObject var weatherVM: WeatherViewModel
    var body: some View {
        ScrollView {
            VStack{
                /// ForEach which loops through daily weather data and return each items info
                ForEach(weatherVM.daily, id: \.wind_speed){ weather in
                    HStack{
                        /// Image
                        Spacer()
                        AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(weather.weather.first!.icon)@2x.png")!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)

                        } placeholder: {
                            ProgressView()
                        }
                        VStack{
                           /// Parameters
                            VStack(spacing: 7){
                                HStack{
                                    Label("Temperature", systemImage: "thermometer")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Spacer()
                                    Text("\(weather.temp.day - 273.15, specifier: "%.2f") °C")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.blue)
                                }
                                HStack{
                                    Label("Pressure", systemImage: "speedometer")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Spacer()
                                    Text("\(weather.pressure, specifier: "%.2f") hPa")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.blue)
                                }
                                HStack{
                                    Label("Wind speed", systemImage: "wind")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    Spacer()
                                    Text("\(weather.wind_speed, specifier: "%.2f") km/h")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.blue)
                                }
                                
                            }
                        }.padding()
                    }
                }
            }
        }.padding()
    }
}

struct DailyWeatherForecast_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherForecast(weatherVM: WeatherViewModel())
    }
}
