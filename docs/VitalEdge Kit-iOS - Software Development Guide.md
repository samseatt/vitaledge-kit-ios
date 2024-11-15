# Software Development Guide

**Project**: VitalEdge Kit - iOS  
**Version**: 1.0  
**Date**: [Date]  
**Author**: Sam Seatt, Team: Xmed

This **Software Development Guide** ensures a structured approach to setting up, developing, and extending the VitalEdge Kit - iOS app. This guide promotes consistency, maintainability, and modularity while supporting future expansion.

---

### Table of Contents

1. [Project Setup](#1-project-setup)
2. [Development Environment](#2-development-environment)
3. [Core Development Phases](#3-core-development-phases)
4. [Software Development Best Practices](#4-software-development-best-practices)
5. [Testing and Debugging](#5-testing-and-debugging)
6. [Project Extension and Maintenance](#6-project-extension-and-maintenance)
7. [Resources and References](#7-resources-and-references)

---

## 1. Project Setup

### 1.1 Prerequisites
- **Hardware**: Intel-based MacBook Pro or later, running macOS Ventura (or newer).
- **Software**:
  - **Xcode**: Version 14.3.1 (or newer).
  - **Swift**: Version 5.8.1.
  - **Apple Developer Account**: Enrollment in the Apple Developer Program is required for device testing and App Store deployment.

### 1.2 Setting Up the Project in Xcode
1. **Open Xcode** and create a new project:
   - Select **App** under iOS.
   - Choose **Swift** as the language and **SwiftUI** for the user interface.
   - Name the project `VitalEdgeKit` and set an **Organization Identifier** (e.g., `com.xmed`).
   - Select **iOS** as the target platform.

2. **Configure Signing & Capabilities**:
   - Go to **Signing & Capabilities** in the project navigator.
   - Under **Team**, select your Apple Developer account.
   - Add the **HealthKit** capability:
     - Click **+ Capability** and select **HealthKit** from the list.

3. **Create Folder Structure**:
   - Organize files with a `Sources` folder at the project’s root.
   - Inside `Sources`, create folders for **Services**, **Views**, **Models**, and **Utilities**.
   - Add a `Resources` folder for assets like icons, images, and JSON files.

---

## 2. Development Environment

### 2.1 HealthKit Integration Setup
- HealthKit integration requires `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription` keys in `Info.plist` to request user permissions.
- Example entries in **Info.plist**:
  ```xml
  <key>NSHealthShareUsageDescription</key>
  <string>VitalEdge Kit requires access to your health data to monitor health metrics.</string>
  <key>NSHealthUpdateUsageDescription</key>
  <string>VitalEdge Kit requires access to update your health data.</string>
  ```

### 2.2 Dependencies and Libraries
- **Combine Framework**: For handling asynchronous data, such as real-time data monitoring and API requests.
- **SwiftUI**: For building the user interface with responsive design and declarative syntax.
- **URLSession**: Used for networking and transmitting data to the VitalEdge Data Aggregator and IoT endpoints.

---

## 3. Core Development Phases

### 3.1 Implementing HealthKitService
- **Purpose**: To retrieve health metrics from HealthKit, including heart rate, step count, and calories burned.
- **Steps**:
  1. Create a `HealthKitService.swift` file in the `Services` folder.
  2. Define functions for retrieving health data:
     - **fetchLatestHeartRate**: Fetches the latest heart rate reading.
     - **fetchStepCount**: Aggregates daily steps.
     - **fetchActiveCaloriesBurned**: Aggregates daily active calories.
  3. Handle permissions and error handling, logging errors for unauthorized access or data retrieval failures.

#### Example Code for `fetchLatestHeartRate`:
   ```swift
   func fetchLatestHeartRate(completion: @escaping (Double?, Error?) -> Void) {
       // Code to fetch heart rate from HealthKit
   }
   ```

### 3.2 DataTransmissionService
- **Purpose**: Transmits data to the central aggregator and IoT endpoints using HTTP POST requests.
- **Steps**:
  1. Create `DataTransmissionService.swift` in the `Services` folder.
  2. Define functions:
     - **sendDataToAPI**: Sends daily summary data to the Data Aggregator.
     - **sendDataToIoTEndpoint**: Sends real-time heart rate to IoT endpoint.
  3. Implement retries and error handling for failed requests, logging network errors and transmission statuses.

#### Example Code for `sendDataToAPI`:
   ```swift
   func sendDataToAPI(with jsonData: [String: Any]) {
       // Code to transmit data to API
   }
   ```

### 3.3 ConfigurationView and Timer Setup
- **Purpose**: Provides user settings for configuring the IoT transmission interval and monitoring options.
- **Steps**:
  1. Create `ConfigurationView.swift` in the `Views` folder.
  2. Add **Stepper** for interval adjustment and **Toggle** switches for monitoring options.
  3. Use `UserDefaults` to persist settings across app sessions.

#### Example Code for Configuration:
   ```swift
   @AppStorage("iotTransmissionInterval") private var iotTransmissionInterval: Double = 5
   ```

---

## 4. Software Development Best Practices

### 4.1 Code Modularity and Reusability
- **Modular Services**: Isolate services such as `HealthKitService` and `DataTransmissionService` to make them easily testable and reusable.
- **Reusable UI Components**: Create reusable UI components for buttons, alerts, and text labels that are used across multiple views.

### 4.2 Error Handling and Logging
- Implement comprehensive error handling in all services:
  - Use `try-catch` for error-prone operations and log errors to help with debugging.
  - Provide user-friendly error messages, especially for permissions or network failures.

### 4.3 Data Security and Privacy
- **HealthKit Compliance**: Always request user permissions before accessing health data.
- **Secure Data Transmission**: Use HTTPS for all transmissions. Consider adding end-to-end encryption for sensitive health metrics in the future.

### 4.4 SwiftUI and Combine Best Practices
- Use **Combine** to handle asynchronous data fetching and updates, especially for real-time data monitoring.
- Rely on **State Management** (`@State`, `@Binding`, `@AppStorage`) in SwiftUI for consistent UI updates in response to data changes.

---

## 5. Testing and Debugging

### 5.1 Unit Testing
- Write unit tests for `HealthKitService` and `DataTransmissionService` to verify data retrieval and transmission functionality.
- **Mock Data**: Use mock objects and services to simulate HealthKit data, especially when testing on simulators.

### 5.2 Real Device Testing
- Since HealthKit data is limited in simulators, test real-time monitoring and HealthKit access on an actual device.
- **Network Testing**: Verify API endpoint connectivity and error handling under various network conditions.

### 5.3 Debugging and Logging
- Use **print statements** for basic logging during development.
- For advanced logging, consider integrating a logging framework like **OSLog** for categorized and severity-based logging.

---

## 6. Project Extension and Maintenance

### 6.1 Extending Health Data Types
To add new health data types:
1. Add new HealthKit queries in `HealthKitService`.
2. Update the payload format in `DataTransmissionService` to include new data types.
3. Modify `sendDataToAPI` and `sendDataToIoTEndpoint` to handle additional data fields as needed.

### 6.2 Adding New Configuration Options
1. Define new settings in `UserDefaults` using `@AppStorage`.
2. Add UI elements in `ConfigurationView` for user interaction.
3. Update dependent components to respect the new settings.

### 6.3 Scheduled Background Data Fetching
To support background fetching in future releases:
- Configure `BackgroundTasks` to periodically fetch and send data even when the app is not active.
- Ensure compliance with Apple’s guidelines on background execution and HealthKit usage.

---

## 7. Resources and References

- **Apple Developer Documentation**: [HealthKit](https://developer.apple.com/documentation/healthkit), [Combine](https://developer.apple.com/documentation/combine), [SwiftUI](https://developer.apple.com/documentation/swiftui)
- **Apple Human Interface Guidelines**: Follow guidelines for UI/UX best practices.
- **Swift Documentation**: Refer to [Swift.org](https://swift.org/documentation/) for language-specific best practices and syntax help.
