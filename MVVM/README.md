### Introduction

Model–View–ViewModel (MVVM) is a software architectural pattern that separates the graphical user interface (GUI) development from the business logic (the model), ensuring the view isn’t dependent on a specific model.

The view model in MVVM acts as a value converter, exposing and converting data from the model to be easily managed and presented. It handles most of the view's display logic

### History
MVVM was created by Microsoft architects Ken Cooper and Ted Peters to simplify event-driven programming for user interfaces. MVVM was incorporated into Windows Presentation Foundation (WPF) and Silverlight. In 2005, Microsoft architect John Gossman announced the pattern on his blog.

### Rationale
MVVM was created to eliminate most of the GUI code from the view layer by using data binding in WPF. This allows UX developers to focus on the design using markup languages like XAML, while application developers manage the view model. This separation of roles boosts productivity, allowing parallel work streams. Even for single developers, separating the view from the model is useful, as the UI tends to change frequently during development based on feedback.

The MVVM pattern aims to combine the separation of concerns from MVC with the data-binding capabilities of modern frameworks. By binding data close to the application model and leveraging validation in the view model, it reduces the need for direct manipulation of the view, minimizing code-behind.

### Criticism

However, John Gossman, one of the original architects, has critiqued MVVM, stating that it can be overkill for simple UIs. For larger applications, upfront generalization of the view model can be challenging, and heavy data binding may impact performance.

### Components of MVVM pattern
The MVVM pattern consists of four key components: the Model, View, View Model, and Binder.

### View

#### Traditional Definition

Similar to MVC and MVP, the view defines the layout and appearance of what the user sees. It interacts with the view model via data binding and responds to user interactions like clicks, gestures, or input.

#### Modern SwiftUI Implementation

In SwiftUI, the view is a declarative representation of the user interface, built using Swift. Views describe how the UI should appear, and SwiftUI manages updates automatically when the data changes. Using SwiftUI’s declarative syntax, components like Text, Button, and List are defined in a hierarchical structure. One key feature is that SwiftUI automatically re-renders the view when there’s a change in data or state, minimizing the need for manual updates like in UIKit. The views bind directly to data in the view model through property wrappers like:

```
@StateObject: For owning view models.

@ObservedObject: For passing view models.

@Binding: For two-way bindings.

@State: For local, view-specific state.
```
  

### View Model

#### Traditional Definition

This is an abstraction of the view, exposing public properties and commands. Unlike the controller in MVC or presenter in MVP, the view model doesn't directly reference the view. Instead, the view binds directly to it, requiring a binding technology to function efficiently.

#### Modern SwiftUI Implementation

The view model in Swift (SwiftUI) serves as an intermediary between the model and the view. It is often a class that conforms to ObservableObject, allowing the view to observe changes in the data. In SwiftUI, you use property wrappers like @Published within the view model to notify the view of changes, triggering re-rendering automatically. The view model is responsible for exposing the data in a format that the view can easily display and handles any business logic related to user interactions, such as:

- Transforming data for the view: Formatting data in a way that’s easy for the view to display. For instance:  
  
```
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
```
- Filtering Data for the View:
```
@Published var filteredUsers: [User] = []

func filterUsers(olderThan age: Int) {
	filteredUsers = users.filter { $0.age > age }
}
```
- Handling User Input: Managing user actions (such as button taps or form submissions) and coordinating the necessary operations between the view and the model.
- State management: Keeping track of the UI's current state (e.g., whether a button is enabled or what the selected item in a list is).
- Error handling: Communicating any issues (like validation failures) back to the UI in a user-friendly way.

  

### Model

#### Traditional Definition
The model represents the real state of the content. It can either refer to the domain model (object-oriented) or the data access layer (data-centric).

#### Modern SwiftUI Implementation

In Swift (SwiftUI), the model typically represents the underlying data or business logic. It could be a struct, class, or enum that encapsulates your app's state, usually adhering to the Codable and Identifiable protocol if you're working with external data like APIs. The model is responsible for the actual business logic and data handling, and it should be kept separate from the view. In practice, your model might communicate with a backend service or handle local data persistence using frameworks like CoreData or CloudKit.

The model is responsible for the core business logic that is tied directly to the data and its management. This includes things like:

  

- Raw Data Properties (Business Entities):
These are the fundamental properties that represent your business data in its purest form. They should be primitive types or simple structs that hold the core information without any presentation logic. These properties are the "source of truth" for your data.
```
struct Weather {
	let temperature: Double // Basic numerical value
	let humidity: Int // Simple percentage
	let windSpeed: Double // Raw measurement
	let pressure: Double // Basic atmospheric pressure
	let timestamp: Date // Time of measurement
}
```

- Domain-Specific Types/Enums:
These are custom types that represent concepts specific to your business domain. They help make your code more type-safe and self-documenting by encoding business rules and valid states directly into the type system. Instead of using strings or numbers that could contain invalid values, you create specific types that can only represent valid domain concepts.
```
struct Weather {
	enum WeatherCondition: String {
		case sunny, cloudy, rainy, snowy
	}

	let condition: WeatherCondition
}
```

- Business validation rules: 
Ensuring that data conforms to business rules (e.g., valid temperature ranges).
These are the rules that ensure your data meets business requirements. They protect the integrity of your model by enforcing valid ranges, relationships, and states. These rules should reflect real-world constraints and business requirements.
```
private static let validTemperatureRange = -100.0...150.0
private static let validHumidityRange = 0...100
private static let validWindSpeedRange = 0.0...500.0
```
- Business logic/Calculations: 
Any logic that governs how the data should behave (e.g., Celsius to Fahrenheit conversion).
These are computations and transformations that reflect business rules or natural phenomena. They should only deal with business concepts, not presentation. These calculations are often derived from raw properties but represent meaningful business concepts.

  
```
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
```
- Should be UI-independent and framework-independent


### Binder

#### Traditional Definition
In MVVM, data and command-binding occur implicitly. In Microsoft's stack, the binder is typically XAML, which automates the communication between the view and view model, reducing the need for boilerplate code. Outside the Microsoft ecosystem, declarative data-binding technology is essential for MVVM, otherwise MVP or MVC would be more suitable."

#### Modern SwiftUI Implementation
In SwiftUI, the concept of a binder is implicit through the use of property wrappers such as @State, @Binding, @Published, @StateObject, @ObservedObject, and @EnvironmentObject. These wrappers act as the bridge between the view and view model, automatically synchronizing data and UI state. Unlike platforms like WPF where a separate binder is needed, SwiftUI’s declarative syntax and property wrappers simplify the binding process, eliminating boilerplate code for synchronizing the view with the data.

For advanced data flows:
- Combine framework

  

### Additional Modern Components
#### Service Layer
The Service layer acts as an intermediary between the view models and external data sources or APIs. It handles the business operations and complex workflows that span multiple repositories or external services. This layer abstracts away the complexity of coordinating multiple data sources and provides a clean interface for the view models to consume.

```
protocol WeatherServiceProtocol {
	func fetchCurrentWeather(for location: Location) async throws -> Weather
	func fetchForecast(days: Int) async throws -> [Weather]
}

class WeatherService: WeatherServiceProtocol {
	private let weatherRepository: WeatherRepositoryProtocol
	private let locationService: LocationServiceProtocol
	
	init(
		weatherRepository: WeatherRepositoryProtocol,
		locationService: LocationServiceProtocol
	) {
		self.weatherRepository = weatherRepository
		self.locationService = locationService
	}

	func fetchCurrentWeather(for location: Location) async throws -> Weather {
		// Coordinate between repositories and transform data
		let coordinates = try await locationService.getCoordinates(for: location)
		let weatherData = try await weatherRepository.fetchWeather(lat: coordinates.lat,
		lon: coordinates.lon)
		return weatherData
	}
}
```
#### Repository Layer
The Repository layer provides an abstraction over data sources, whether they're local (Core Data, UserDefaults) or remote (REST APIs, GraphQL). It handles the specifics of data persistence and retrieval, providing a clean interface that shields the rest of the application from the implementation details of data storage.

```
protocol WeatherRepositoryProtocol {
	func fetchWeather(lat: Double, lon: Double) async throws -> Weather
	func cacheWeather(_ weather: Weather) async throws
	func getCachedWeather() async throws -> Weather?
}

class WeatherRepository: WeatherRepositoryProtocol {
	private let apiClient: APIClient
	private let cache: CacheManager

	init(apiClient: APIClient, cache: CacheManager) {
		self.apiClient = apiClient
		self.cache = cache
	}

	func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
		// Check cache first
		if let cached = try await getCachedWeather() {
			return cached
		}

		// Fetch from API if not cached
		let weather = try await apiClient.fetch(endpoint: .weather(lat: lat, lon: lon))
		try await cacheWeather(weather)
		return weather
	}
}
```
#### Coordinator/Router Layer
The Coordinator pattern handles navigation flow and screen transitions in the application. It removes navigation logic from view models and provides a centralized place to manage the app's flow.

### Additional information
#### Reliability and Scalability
When implementing MVVM in app development with Swift and SwiftUI, it’s crucial to consider both reliability and scalability. MVVM's clear separation of concerns enhances reliability by isolating business logic in the view model, making the codebase easier to maintain and test. This reduces the risk of bugs when making changes to the user interface or logic.

For scalability, MVVM allows apps to grow smoothly. As the app’s features expand, adding new views or modifying existing ones doesn’t disrupt the underlying business logic. The view model can evolve independently of the view, which makes it easier to scale both functionality and user interface over time. However, keep in mind that overusing MVVM in simple apps might introduce unnecessary complexity.

#### Technologies and Libraries That Can Help
When working with MVVM in Swift and SwiftUI, there are a few technologies and libraries that can greatly assist in streamlining the process.

- Combine: Apple’s Combine framework simplifies data binding between the view and view model, allowing for reactive programming with SwiftUI. Using @Published properties in the view model and @StateObject or @ObservedObject in the view helps manage state effectively.
- SwiftLint: For maintaining clean and consistent code structure, SwiftLint can help ensure your MVVM implementation follows best practices.
- XCTest: Testing frameworks like XCTest for unit testing and Quick/Nimble for behavior-driven testing are key to ensuring the reliability of your view models without needing to test the UI.

#### When starting from scratch or switching to MVVM
When implementing MVVM in a Swift/SwiftUI app from scratch or switching to it, consider the following:
- Clear Separation of Concerns: Ensure that you properly separate the view, view model, and model layers. The view should only handle the UI, while the view model manages the business logic and communicates with the model. This will help avoid code duplication and make future changes easier.
- Data Binding: SwiftUI's @Binding, @Published, and @StateObject make data binding straightforward. Leverage these features to ensure seamless communication between the view and view model, but be mindful not to overuse them, which can lead to excessive re-rendering.
- ViewModel Lifecycle: Manage the lifecycle of your view models carefully. For example, using @StateObject when a view model needs to persist across the lifecycle of the view is important, whereas @ObservedObject should be used when it’s not retained.
- Testability: One of the key benefits of MVVM is making your app easier to test. Focus on writing unit tests for your view models to ensure they work as expected without relying on the UI.
- Performance: As the app grows, data binding in large or complex views can introduce performance issues. Keep an eye on performance, especially with large datasets or complex views, and consider optimizing your bindings.