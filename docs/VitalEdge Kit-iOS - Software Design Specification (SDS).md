# Software Design Specification (SDS)

**Project**: VitalEdge Kit - iOS  
**Version**: 1.0  
**Date**: [Date]  
**Author**: Sam Seatt, Team: Xmed

---

### 1. Introduction

#### 1.1 Purpose
This Software Design Specification (SDS) document outlines the design, architecture, data flows, and detailed software components for the **VitalEdge Kit - iOS** application. It serves as a technical blueprint for developers and stakeholders, ensuring consistency, modularity, and maintainability.

#### 1.2 Scope
VitalEdge Kit - iOS collects health metrics using Apple’s HealthKit framework and transmits selected data to endpoints in the VitalEdge ecosystem, including a central data aggregator and IoT endpoints. The application is intended for real-time and periodic data transmission, configurable by the user and focused on providing insights for personalized health monitoring.

---

### 2. System Overview

#### 2.1 System Architecture

The VitalEdge Kit - iOS app follows a modular architecture:
- **Health Data Collection**: HealthKit serves as the data source for health metrics.
- **Data Transmission Module**: Handles HTTP requests for data transmission to endpoints.
- **Configuration Module**: Allows users to set preferences for data transmission intervals and real-time monitoring.
- **User Interface**: Displays configuration settings and integrates a simple dashboard for health metrics (planned).

#### 2.2 High-Level Data Flow

1. **Data Retrieval**: The app retrieves data from HealthKit for metrics such as heart rate, step count, and calories burned.
2. **Data Aggregation**: A daily summary aggregates step count and calories burned.
3. **Data Transmission**: The app transmits data to:
   - **VitalEdge Data Aggregator**: For daily summaries.
   - **IoT Endpoint**: For real-time heart rate monitoring.
4. **User Configuration**: Allows users to set interval preferences and toggles.

---

### 3. Detailed Design

#### 3.1 Modules and Components

1. **HealthKitService**
   - **Purpose**: Manages HealthKit data access and permissions.
   - **Functions**:
     - `fetchLatestHeartRate`: Retrieves the latest heart rate sample.
     - `fetchStepCount`: Aggregates step count over a specified date.
     - `fetchActiveCaloriesBurned`: Aggregates active calories burned over a specified date.
   - **Error Handling**: Logs errors for any HealthKit request failures and provides user feedback.

2. **DataTransmissionService**
   - **Purpose**: Handles HTTP requests to transmit data to the configured endpoints.
   - **Functions**:
     - `sendDataToAPI`: Sends data payloads to the VitalEdge Data Aggregator.
     - `sendDataToIoTEndpoint`: Sends data payloads to the IoT endpoint for real-time monitoring.
   - **Retry Mechanism**: Implements basic retry logic for failed transmissions.
   - **Error Handling**: Logs HTTP errors and provides feedback on transmission status.

3. **ConfigurationService**
   - **Purpose**: Manages user preferences and configuration settings.
   - **Storage**: Uses `UserDefaults` to persist settings.
   - **Settings**:
     - **IoT Transmission Interval**: Configurable interval for real-time heart rate transmission.
     - **Real-Time Monitoring Toggle**: Enables/disables real-time monitoring for heart rate.
     - **Daily Summary Toggle**: Enables/disables daily summary transmission.

4. **User Interface Components**
   - **ConfigurationView**: A SwiftUI view for user configuration settings.
   - **DashboardView** (Future): Displays current and historical health data.
   - **ContentView**: Primary view managing data transmission, configuration access, and settings triggers.

---

### 3.2 Class Diagrams

Below is a simplified diagram of the primary classes and their relationships.

```plaintext
+--------------------+
|  HealthKitService  |
+--------------------+
| - fetchLatestHeartRate()
| - fetchStepCount()
| - fetchActiveCaloriesBurned()
+--------------------+

+------------------------+       +--------------------------+
|  DataTransmission      |       |  ConfigurationService    |
+------------------------+       +--------------------------+
| - sendDataToAPI()      |       | - getTransmissionInterval()
| - sendDataToIoTEndpoint|       | - setRealTimeMonitoring()
+------------------------+       +--------------------------+

+-----------------------+
|    User Interface     |
+-----------------------+
| - ConfigurationView() |
| - ContentView()       |
+-----------------------+
```

---

### 3.3 Data Models

#### 3.3.1 Health Data Models
The following data models represent the payloads for each API request.

1. **VitalEdge Data Aggregator Payload**
   ```swift
   struct AggregatorPayload: Codable {
       let userId: String
       let timestamp: String
       let stepCount: Int
       let caloriesBurned: Int
   }
   ```

2. **IoT Heart Rate Payload**
   ```swift
   struct IoTPayload: Codable {
       let userId: String
       let timestamp: String
       let heartRate: Int
   }
   ```

#### 3.3.2 Configuration Settings
Configuration settings are stored in `UserDefaults` for persistence:
- **iotTransmissionInterval** (Double): Interval in minutes.
- **realTimeMonitoringEnabled** (Bool): Toggle for real-time monitoring.
- **dailySummaryEnabled** (Bool): Toggle for daily summary.

---

### 3.4 Data Flow Diagrams

#### 3.4.1 Daily Summary Data Flow

```plaintext
+-----------+       +------------+       +-----------------+
|  Health   |-----> |  Health    |-----> | DataTransmission|
|  Data     |       |  Aggregator|       |  to Aggregator  |
+-----------+       +------------+       +-----------------+
                    (Aggregates)
```

#### 3.4.2 Real-Time IoT Data Flow

```plaintext
+-----------+       +-------------------+       +-----------------+
|  Health   |-----> |  Real-Time Timer  |-----> | DataTransmission|
|  Data     |       |  Trigger          |       | to IoT Endpoint |
+-----------+       +-------------------+       +-----------------+
                    (Triggers every X min)
```

---

### 4. System Interface Design

#### 4.1 User Interface Design

- **ConfigurationView**:
  - Provides options to set the IoT transmission interval (Stepper).
  - Toggles for enabling/disabling real-time monitoring and daily summary.
- **DashboardView** (Future):
  - Displays a graphical summary of step count, calories burned, and heart rate data.
  
#### 4.2 API Interface Design

1. **VitalEdge Data Aggregator API**:
   - **Method**: `POST`
   - **Endpoint**: `/api/healthkit`
   - **Payload**: `AggregatorPayload`
   - **Response Codes**:
     - `200 OK`: Data successfully received.
     - `400 Bad Request`: Invalid data.

2. **IoT Endpoint API**:
   - **Method**: `POST`
   - **Endpoint**: `/api/iot-heart-rate`
   - **Payload**: `IoTPayload`
   - **Response Codes**:
     - `200 OK`: Data successfully received.
     - `400 Bad Request`: Invalid data.

---

### 5. Detailed Functional Flows

#### 5.1 Real-Time Heart Rate Monitoring

1. User enables **Real-Time Monitoring** in settings.
2. The app sets a timer based on `iotTransmissionInterval`.
3. Every interval, the timer triggers:
   - `HealthKitService.fetchLatestHeartRate`.
   - Heart rate data is retrieved and sent to IoT endpoint.
4. The timer stops if real-time monitoring is disabled.

#### 5.2 Daily Summary Transmission

1. User enables **Daily Summary** in settings.
2. Every day at a predefined time (e.g., midnight):
   - `HealthKitService.fetchStepCount` and `fetchActiveCaloriesBurned` are triggered.
3. Aggregated data is transmitted to the VitalEdge Data Aggregator endpoint.
4. If daily summary is disabled, this process is skipped.

---

### 6. Error Handling and Logging

- **Data Transmission**: Retry mechanism for network failures. Logs errors with context (e.g., endpoint, payload).
- **HealthKit Data Fetching**: Logs errors when HealthKit requests fail, providing details on unavailable data types or permissions issues.
- **UI Feedback**: Errors or network issues display user-friendly messages in the UI.

---

### 7. Security and Compliance

1. **HealthKit Permissions**: All HealthKit data access must be authorized by the user.
2. **Data Transmission Security**:
   - Data is transmitted over HTTPS.
   - In future releases, data encryption (AES-256) will be added for additional security.
3. **User Data Privacy**:
   - `UserDefaults` is used for non-sensitive data.
   - Users can revoke HealthKit permissions at any time.

---

### 8. Future Considerations

- **User Authentication**: Adding authentication to validate user access.
- **Additional Data Types**: Integrate other HealthKit metrics as needs evolve.
- **Push Notifications**: Add notifications for real-time health alerts or daily summaries.
- **Blockchain Integration**: Implement blockchain to maintain immutable health data logs.



---

### 9. Appendices

#### 9.1 Sample JSON Payloads

- **Aggregator Payload**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "stepCount": 1000,
      "caloriesBurned": 200
  }
  ```

- **IoT Payload**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "heartRate": 75
  }
  ```
