# iOS Architecture Rules

- Use MVVM architecture for presentation layer
- Use Clean architecture for overall system
- Use Coordinator pattern for navigation
- Use Protocol Oriented Programming for Better Testability
- Use async/await for all async work
- Use actors for shared mutable state
- Use Main Actor for View Models 
- Run Heavy Task like Networking and Database writing on the Background Thread
- Background Thread To Main Thread should be Handled by Using MainActor.run 
- Avoid business logic in Views
- Use dependency injection via initializer
- Follow folder structure:
  - Features/
  - Core/
