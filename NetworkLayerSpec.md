Core Network Infrastructure (Protocol-Oriented)
Why
A highly scalable, secure, and testable network layer is the backbone of any robust iOS application, particularly in fast-paced startup, fintech, or social environments. By utilizing a Protocol-Oriented approach, we decouple the network logic from our view models, ensuring high testability through dependency injection. This architecture establishes a solid foundation that can seamlessly scale from initial ideation all the way to a robust App Store deployment.
What
A native, zero-dependency Swift network layer using Protocol-Oriented Programming (POP) and modern Swift Concurrency (async/await). The deliverable includes the core protocols (Endpoint, NetworkDispatcher), a concrete implementation using URLSession, custom error mapping, and a suite of protocol-based mock classes for reliable unit testing.
Constraints
Must
    •    Utilize native Foundation and URLSession.
    •    Exclusively use Swift Concurrency (async/await) for asynchronous operations.
    •    Ensure all network services depend on abstractions (Protocols) rather than concrete implementations.
    •    Parse responses using Swift's Decodable protocol.
Must Not
    •    Introduce third-party networking dependencies (e.g., Alamofire, Moya).
    •    Expose raw URLRequest or Data objects to the presentation/ViewModel layer.
    •    Force unwrap optionals (!) anywhere in the parsing or networking pipeline.
Out of Scope
    •    Local database caching (CoreData/SwiftData integration).
    •    WebSocket (WSS) implementations or long-polling mechanisms.
    •    Authentication token refresh logic (to be handled in a separate Interceptor/Middleware feature).
Current State
Currently, There is no folder and file structure  for Network layer create it inside the core Folder
    
Tasks
T1: Define Core Networking Protocols
What: Create the foundational abstractions. Define the Endpoint protocol to encapsulate URL, HTTP method, headers, and body. Define the NetworkDispatcher protocol that dictates how requests are executed. Files: Networking/Protocols/Endpoint.swift, Networking/Protocols/NetworkDispatcher.swift Verify: Ensure project compiles. No concrete implementations should exist yet.
T2: Implement Custom Error Handling
What: Create a comprehensive NetworkError enum conforming to Error and LocalizedError. This should cover invalid URLs, HTTP status code errors (4xx, 5xx), decoding failures, and connectivity issues. Files: Networking/Errors/NetworkError.swift Verify: Run standard linter.
T3: Build the Concrete URLSession Dispatcher
What: Implement URLSessionNetworkDispatcher conforming to NetworkDispatcher. This struct will take an injected URLSession and execute the Endpoint requests, mapping raw Data to Decodable generic types. Files: Networking/Services/URLSessionNetworkDispatcher.swift Verify: Build the project to ensure protocol conformance is satisfied.
T4: Create Mocking Infrastructure for Testing
What: Build a MockNetworkDispatcher that conforms to NetworkDispatcher. It should allow injecting pre-defined .json data or specific NetworkError states to simulate API responses without hitting the network. Files: Tests/Mocks/MockNetworkDispatcher.swift Verify:  Ensure project compiles.
Validation
The feature is complete when the core networking protocols are established,and the view models can successfully fetch data using injected network dispatchers.
    •    Ensure project compiles. 

