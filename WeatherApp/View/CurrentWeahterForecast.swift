//
//  ContentView.swift
//  WeatherApp
//
//  Created by Natanael Jop on 10/05/2022.
//

import SwiftUI
import CoreLocation

struct CurrentWeahterForecast: View {
    @State var isSearched = false
    @State var errorMessage = ""
    @ObservedObject var weatherVM: WeatherViewModel
    var body: some View {
        VStack{
            Text("Weather")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .padding()
            /// Top part
            HStack{
                CustomSearchBar(placeholder: Text("Write down city..."), text: $weatherVM.city)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Button(action: {
                    getCoordinateFrom(address: weatherVM.city) { coordinate, error in
                        guard let coordinate = coordinate, error == nil else { return errorMessage = "Wrong name of the city."}
                        weatherVM.lat = coordinate.latitude.description
                        weatherVM.lon = coordinate.longitude.description
                        errorMessage = ""
                    loadData()
                    isSearched = true
                    }
                }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .black))
                }.padding(10)
            }.padding()
                .padding(.horizontal, 30)
            
            Spacer()
            /// Error message view
            if errorMessage != "" {
                VStack{
                    Spacer()
                    Text(errorMessage)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(20)
                    Spacer()
                }.padding(.bottom, 100)
            }else if isSearched {
                
                ///  Current weather view
                VStack(spacing: 20){
                    
                    AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(weatherVM.currentWeather.weather.first!.icon)@2x.png")!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)

                    } placeholder: {
                        ProgressView()
                    }
                    
                    HStack{
                        Label("Temperature", systemImage: "thermometer")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(weatherVM.currentWeather.temp - 273.15, specifier: "%.2f") °C")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Label("Pressure", systemImage: "speedometer")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(weatherVM.currentWeather.pressure, specifier: "%.2f") hPa")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Label("Wind speed", systemImage: "wind")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(weatherVM.currentWeather.wind_speed, specifier: "%.2f") km/h")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    
                }.padding()
                    .padding(.bottom, 100)
                Spacer()
                /// Navigation link to daily weather forecast
                NavigationLink(destination:{
                    DailyWeatherForecast(weatherVM: weatherVM)
                }) {
                    ZStack{
                        Color.blue
                        Text("Check forecast for next 7 days")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }.cornerRadius(20)
                    .frame(height: 70)
                        .padding()
                }

            }else{
                /// Default view
                VStack{
                    Spacer()
                    Text("Search for the city you want to see the weather forecast")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(20)
                    Spacer()
                }.padding(.bottom, 100)
            }
        }
    }
    func loadData() {
        loadCurrent()
        loadDaily()
    }
    func loadCurrent(){
        /// api url
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(weatherVM.lat)&lon=\(weatherVM.lon)&exclude=minutely,hourly,alerts&appid=7a0c9e32df5eb61e8e07a38042fe8291") else {
            return print("nie działa 🍭")
        }
        /// decoding data comparing the WeatherCompsModel
        do {
            let data = try Data(contentsOf: url)
            
            if (try? JSONDecoder().decode(WeatherCompsModel.self, from: data)) != nil{
                print("nie wiem co sie dzieje tutaj")
            }
            
        }catch{
            print("tutaj wywaliło 🤡")
        }
        let urlRequest = URLRequest(url: url)

        /// Sending urlRequst
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            /// decoding api data and compaing data to CurrentWeatherModel
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedWeather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                        weatherVM.currentWeather = decodedWeather.current
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    func loadDaily(){
        /// api url
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(weatherVM.lat)&lon=\(weatherVM.lon)&exclude=minutely,hourly,alerts&appid=7a0c9e32df5eb61e8e07a38042fe8291") else {
            return print("nie działa 🍭")
        }
        /// decoding data comparing the DailyWeatherCompsModel
        do {
            let data = try Data(contentsOf: url)
            
            if (try? JSONDecoder().decode(DailyWeatherCompsModel.self, from: data)) != nil{
                print("nie wiem co sie dzieje tutaj")
            }
            
        }catch{
            print("tutaj wywaliło 🤡")
        }
        let urlRequest = URLRequest(url: url)

        /// Sending urlRequst
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            /// decoding api data and compaing data to DailyWeatherModel
            ///
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedWeather = try JSONDecoder().decode(DailyWeatherModel.self, from: data)
                        weatherVM.daily = decodedWeather.daily
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    /// function which trasforms loaction to coordtinates
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }

}

struct Previews_CurrentWeahterForecast_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeahterForecast(weatherVM: WeatherViewModel())
    }
}
