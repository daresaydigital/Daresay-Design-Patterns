// WeatherViewModel.swift
// Demonstrates "View Model" section from documentation:
// "The view model serves as an intermediary between the model and the view"
// Created by Diego Leon on 2024-09-10.

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
  // Published properties for view binding as mentioned in documentation
  @Published var weatherData: WeatherData?
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  // Transforming data for the view as described in documentation
  @Published var formattedTemperature: String = ""
  @Published var weatherDescription: String = ""
  @Published var weatherAlert: String?
  
  private let weatherService: WeatherServiceProtocol
  
  init(weatherService: WeatherServiceProtocol = WeatherService()) {
    self.weatherService = weatherService
  }
  
  // Handling User Input as mentioned in documentation
  func fetchWeather(for city: String) async {
    isLoading = true
    errorMessage = nil
    
    do {
      let data = try await weatherService.getWeather(for: city)
      weatherData = data
      
      // Transform data for view consumption
      updateFormattedData(from: data)
      checkWeatherAlerts(data)
    } catch {
      errorMessage = error.localizedDescription
    }
    
    isLoading = false
  }
  
  // Transforming data for the view as described in documentation
  private func updateFormattedData(from weather: WeatherData) {
    formattedTemperature = String(
      format: "%.1f°C (%.1f°F)",
      weather.temperature,
      weather.temperatureInFahrenheit()
    )
    weatherDescription = """
            Condition: \(weather.condition.rawValue.capitalized)
            Humidity: \(weather.humidity)%
            Wind Speed: \(weather.windSpeed) km/h
            """
  }
  
  // State management and error handling as mentioned in documentation
  private func checkWeatherAlerts(_ weather: WeatherData) {
    if weather.isExtremeWeather {
      weatherAlert = "Extreme weather conditions detected!"
    } else if weather.isFreezing {
      weatherAlert = "Freezing temperatures expected!"
    } else {
      weatherAlert = nil
    }
  }
}
