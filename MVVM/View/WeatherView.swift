//
//  WeatherView.swift
//  MVVMExamples
//
//  Created by Diego Leon on 2024-09-10.
//

import SwiftUI

struct WeatherView: View {
  @StateObject private var viewModel = WeatherViewModel()
  @State private var cityName = ""
  
  var body: some View {
    VStack {
      TextField("Enter city name", text: $cityName)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Button("Get Weather") {
        Task {
          await viewModel.fetchWeather(for: cityName)
        }
      }
      .padding()
      .disabled(cityName.isEmpty)
      
      if viewModel.isLoading {
        ProgressView()
      } else if let weatherData = viewModel.weatherData {
        VStack {
          Text("Temperature: \(weatherData.temperature, specifier: "%.1f")°C")
            .foregroundColor(weatherData.temperature > 30 ? .red : (weatherData.temperature < 10 ? .blue : .black))
          Text("Description: \(weatherData.description)")
        }
      } else if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
      }
    }
    .padding()
  }
}
