// WeatherView.swift
// Demonstrates "View" section from documentation:
// "In SwiftUI, the view is a declarative representation of the user interface"
// Created by Diego Leon on 2024-09-10.

import SwiftUI

struct WeatherView: View {
  // StateObject for owning view models as mentioned in documentation
  @StateObject private var viewModel = WeatherViewModel()
  // State for local, view-specific state as described in documentation
  @State private var cityName = ""
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        // Search Section
        searchSection
        
        // Loading and Error States
        statusSection
        
        // Weather Data Display
        weatherDataSection
      }
      .padding()
      .navigationTitle("Weather App")
    }
  }
  
  // View components split into smaller, focused views
  private var searchSection: some View {
    VStack(spacing: 20) {
      TextField("Enter city name", text: $cityName)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Button("Get Weather") {
        Task {
          await viewModel.fetchWeather(for: cityName)
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(cityName.isEmpty)
    }
  }
  
  private var statusSection: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
      } else if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
      }
    }
  }
  
  private var weatherDataSection: some View {
    Group {
      if let weather = viewModel.weatherData {
        VStack(alignment: .leading, spacing: 10) {
          Text(viewModel.formattedTemperature)
            .font(.title)
            .foregroundColor(weather.isFreezing ? .blue :
                              (weather.temperature > 30 ? .red : .primary))
          
          Text(viewModel.weatherDescription)
            .font(.body)
          
          if let alert = viewModel.weatherAlert {
            Text(alert)
              .foregroundColor(.orange)
              .padding()
              .background(Color.orange.opacity(0.2))
              .cornerRadius(8)
          }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
      }
    }
  }
}
