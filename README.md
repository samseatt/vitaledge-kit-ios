# VitalEdge Kit - iOS

VitalEdge Kit - iOS is a Swift-based application that integrates Apple HealthKit data into the VitalEdge ecosystem. It enables real-time and periodic health data transmission to central and IoT endpoints, contributing to a personalized healthcare system. This app is part of the broader **VitalEdge ecosystem**, which includes microservices, IoT devices, and centralized data aggregation for advanced health monitoring and analytics.

---

## Features

- **HealthKit Integration**:
  - Collects heart rate, step count, and calories burned.
  - Requests user permissions following Apple's HealthKit guidelines.
- **Real-Time Data Transmission**:
  - Sends heart rate data to an IoT endpoint for immediate monitoring.
- **Daily Summary Aggregation**:
  - Transmits daily step count and calories burned to the central VitalEdge Data Aggregator.
- **Configurable Settings**:
  - Set IoT transmission intervals and enable/disable real-time monitoring and daily summaries.
- **Modular Design**:
  - Built for scalability and easy extension of health metrics and endpoints.

---

## Getting Started

### Prerequisites

- macOS Ventura or later
- Xcode 14.3.1 or newer
- Swift 5.8.1
- Apple Developer Account (for device testing)
- iOS 16.4+ device or simulator

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/vitaledge-kit-ios.git
   cd vitaledge-kit-ios
   ```

2. **Open the Project in Xcode**:
   - Open `VitalEdgeKit.xcodeproj` in Xcode.

3. **Configure Signing**:
   - Go to `Signing & Capabilities` in the project settings.
   - Select your development team and enable **HealthKit**.

4. **Run the App**:
   - Choose a simulator or connect a real device.
   - Click **Run** in Xcode.

---

## Project Structure

```plaintext
VitalEdgeKit/
├── Sources/
│   ├── Services/       # HealthKitService and DataTransmissionService
│   ├── Views/          # SwiftUI views (e.g., ContentView, ConfigurationView)
│   ├── Models/         # Data models for API payloads
│   ├── Utilities/      # Helper functions and extensions
├── Resources/          # Assets, Info.plist, and other resources
├── Tests/              # Unit tests
└── README.md           # Project documentation
```

---

## Usage

1. **Configure Settings**:
   - Navigate to the **Configuration Screen** from the main view.
   - Adjust IoT transmission intervals and toggle real-time monitoring or daily summaries.

2. **Send Data**:
   - Use the **Send Daily Summary** button to manually send aggregated data.
   - Use the **Send Heart Rate to IoT Endpoint** button for real-time heart rate data.

3. **Automated Transmission**:
   - Enable real-time monitoring to send heart rate data at configured intervals.
   - Daily summaries are automatically sent at the end of each day.

---

## API Endpoints

### VitalEdge Data Aggregator
- **URL**: `/api/healthkit`
- **Method**: `POST`
- **Payload**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "stepCount": 1000,
      "caloriesBurned": 200
  }
  ```

### IoT Endpoint
- **URL**: `/api/iot-heart-rate`
- **Method**: `POST`
- **Payload**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "heartRate": 75
  }
  ```

---

## Contributing

We welcome contributions to expand the VitalEdge Kit - iOS app. Here's how you can contribute:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your feature description"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a pull request.

---

## Testing

- **Unit Tests**:
  - Run unit tests using the Xcode test suite.
  - Ensure HealthKit data retrieval and API transmissions are covered.
- **Device Testing**:
  - Test HealthKit integrations on a real device, as simulators have limited functionality.

---

## Future Features

- **Additional Health Metrics**: Add support for sleep analysis, respiratory rate, etc.
- **Background Tasks**: Schedule background data fetches and transmissions.
- **Push Notifications**: Notify users of critical health events.
- **Data Encryption**: Implement AES-256 for secure data handling.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Acknowledgments

Special thanks to the Xmed team for conceptualizing and supporting the VitalEdge ecosystem.
