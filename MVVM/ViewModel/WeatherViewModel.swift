//
//  WeatherViewModel.swift
//  MVVMExamples
//
//  Created by Diego Leon on 2024-09-10.
//

import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
  @Published var weatherData: WeatherData?
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var temperatureColor: Color = .black
  
  private let weatherService: WeatherServiceProtocol
  
  init(weatherService: WeatherServiceProtocol = WeatherService()) {
    self.weatherService = weatherService
  }
  
  func fetchWeather(for city: String) async {
    isLoading = true
    errorMessage = nil
    
    do {
      let data = try await weatherService.getWeather(for: city)
      weatherData = data
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
}
