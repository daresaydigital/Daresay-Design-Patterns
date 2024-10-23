# WeatherData - Model
The WeatherData struct represents our data model. It contains the essential information we want to display: city, temperature, and description.

This model is simple and only holds data. It conforms to Codable to allow easy serialization/deserialization.

The Model doesn't contain any business logic or knowledge of other layers.


# WeatherViewModel - ViewModel
The WeatherViewModel class acts as the intermediary between the View and the Model. It handles the business logic and state management.

It's an ObservableObject, allowing the View to observe and react to its changes.

@Published properties automatically notify observers of changes.

It contains logic for fetching weather data and managing the loading/error states.

The ViewModel typically holds a reference to the Model data. It can:
- Transform Model data for the View (e.g., formatting temperature).
- Expose Model data to the View in a more convenient form.
- Maintain UI state that isn't part of the Model (e.g., isLoading, errorMessage).

The ViewModel doesn't update the Model directly. Instead, it:
- Requests data updates from a service layer or repository.
- Updates its own state based on the results from the service layer.
- Prepares data for the View based on the current state.

In this example, this is represented by weatherData.
- Update from ViewModel to Model

The ViewModel interacts with a service layer (WeatherService) to fetch or update data, adding a level of abstraction and separation of concerns.

## Separation of UI logic
Keeping UI logic separate from business logic ensures that each component (View, ViewModel, Model) has a distinct responsibility, making the code more organized, maintainable, and testable.

View-Specific Logic refers to anything that is directly related to:

Presentation Details: Decisions about how to style, format, or arrange UI elements (e.g., colors, fonts, animations).
User Interface Events: Code that directly handles UI events (like button taps, gestures) beyond notifying the ViewModel of the event's occurrence.
Navigation: Deciding when to present or dismiss another screen or view.

For instance:

Let's say you want to change the color of a Text view based on the weather condition.

Incorrect Approach:
// In ViewModel (Not recommended)
@Published var temperatureColor: Color = .black

func updateTemperatureColor(temperature: Double) {
    if temperature > 30 {
        temperatureColor = .red
    } else if temperature < 10 {
        temperatureColor = .blue
    } else {
        temperatureColor = .black
    }
}

Correct Approach:
The ViewModel should only expose the data, like the temperature itself, while the View decides how to present it:

// In the View
if let temperature = viewModel.weatherData?.temperature {
    Text("Temperature: \(temperature, specifier: "%.1f")°C")
        .foregroundColor(temperature > 30 ? .red : (temperature < 10 ? .blue : .black))
}

In the correct approach, the ViewModel only provides the necessary data (temperature), and the View determines how to display that data (like the text color).


# WeatherView - View
The WeatherView struct represents our UI using SwiftUI.
- It uses @StateObject to create and manage the ViewModel instance.
- It observes the ViewModel's published properties and updates the UI accordingly.
- It handles user input (city name) and triggers actions on the ViewModel (fetching weather).
- he View doesn't contain business logic; it delegates user actions to the ViewModel.

# WeatherService - Service Layer

Implements the WeatherServiceProtocol, defining the contract for weather data operations.
Responsible for data operations like fetching weather data (in a real app, this would involve API calls or database operations).
Provides a level of abstraction between the ViewModel and the data source.
Allows for easy mocking in tests by adhering to a protocol.

Service Layer or Repository as the Data Source:
The Service Layer or Repository acts as the middleman between the ViewModel and the actual data source (e.g., API, database).
When the ViewModel requests data, the Service Layer retrieves it (perhaps using network calls or database queries), processes it if necessary, and then returns it to the ViewModel, often in the form of a Model object.
