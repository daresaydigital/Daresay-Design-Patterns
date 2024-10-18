//
//  WeatherService.swift
//  MVVMExamples
//
//  Created by Diego Leon on 2024-09-10.
//

protocol WeatherServiceProtocol {
  func getWeather(for city: String) async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {
  func getWeather(for city: String) async throws -> WeatherData {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
    
    return WeatherData(temperature: 22.5, description: "Partly cloudy")
  }
}
