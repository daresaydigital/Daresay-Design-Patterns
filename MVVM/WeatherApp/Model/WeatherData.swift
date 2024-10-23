// WeatherData.swift
// Demonstrates "Model" section from documentation:
// "The model represents the underlying data or business logic... responsible for core business logic tied directly to data"
// Created by Diego Leon on 2024-09-10.

import Foundation

struct WeatherData: Codable, Identifiable {
  // Raw Data Properties (Business Entities) as mentioned in documentation
  let id: UUID = UUID()
  let temperature: Double
  let humidity: Int
  let windSpeed: Double
  let pressure: Double
  let timestamp: Date
  
  // Domain-Specific Types/Enums as described in documentation
  enum WeatherCondition: String, Codable {
    case sunny, cloudy, rainy, snowy, thunderstorm
  }
  let condition: WeatherCondition
  
  // Business validation rules as mentioned in documentation
  private static let validTemperatureRange = -100.0...150.0
  private static let validHumidityRange = 0...100
  private static let validWindSpeedRange = 0.0...500.0
  
  // Business logic/Calculations as described in documentation
  var isFreezing: Bool {
    temperature <= 0
  }
  
  var isPrecipitating: Bool {
    [.rainy, .snowy, .thunderstorm].contains(condition)
  }
  
  var isExtremeWeather: Bool {
    temperature > 35 || temperature < -10 || windSpeed > 70
  }
  
  func temperatureInFahrenheit() -> Double {
    (temperature * 9/5) + 32
  }
  
  // Domain-specific error types as mentioned in documentation
  enum WeatherError: Error {
    case invalidTemperature
    case invalidHumidity
    case invalidWindSpeed
  }
}
