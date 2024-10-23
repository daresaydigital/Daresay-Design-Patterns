// WeatherService.swift
// Demonstrates "Service Layer" section from documentation:
// "Acts as an intermediary between view models and external data sources"
// Created by Diego Leon on 2024-09-10.

import Foundation

protocol WeatherServiceProtocol {
  func getWeather(for city: String) async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {
  // Simulating network call and data transformation
  func getWeather(for city: String) async throws -> WeatherData {
    // Simulate network delay
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Simulate API response
    return WeatherData(
      temperature: Double.random(in: -5...35),
      humidity: Int.random(in: 30...90),
      windSpeed: Double.random(in: 0...50),
      pressure: Double.random(in: 980...1020),
      timestamp: Date(),
      condition: .sunny
    )
  }
}
