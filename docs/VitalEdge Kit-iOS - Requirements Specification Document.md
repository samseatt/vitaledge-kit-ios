# Requirements Specification Document

**Project**: VitalEdge Kit - iOS  
**Version**: 1.0  
**Date**: November 14, 2024  
**Author**: Sam Seatt / Xmed

---

### 1. Overview

#### 1.1 Purpose
The VitalEdge Kit - iOS app is a Swift-based application designed to integrate health data from Apple’s HealthKit framework, transmit selected metrics to various endpoints in the VitalEdge ecosystem, and provide configurable options for real-time health data monitoring and daily summaries. VitalEdge Kit - iOS focuses on personalized, data-driven insights for patient and healthcare provider use in a non-commercial, betterment-focused environment.

#### 1.2 Scope
VitalEdge Kit - iOS will collect health metrics from iOS and Apple Watch through HealthKit and transmit them to both the **central VitalEdge Data Aggregator** and **IoT endpoints**. This scope includes functionality for real-time and periodic data transmission, a configurable settings interface, and modular architecture, allowing for expansion to additional health metrics and new data endpoints as needed.

#### 1.3 Intended Audience
This document is intended for:
- Development and design teams
- Product and project managers
- QA and testing teams
- Future maintainers and stakeholders within the VitalEdge project

#### 1.4 Definitions and Abbreviations
- **HealthKit**: Apple’s framework for health and fitness data.
- **VitalEdge Data Aggregator**: Central server endpoint for receiving aggregated health data.
- **IoT Endpoint**: A separate endpoint designed to receive real-time heart rate data for monitoring.
- **HKQuantityTypeIdentifier**: HealthKit data types such as step count, heart rate, and active calories burned.

---

### 2. Functional Requirements

#### 2.1 Health Data Collection

##### 2.1.1 Retrieve Health Data from HealthKit
- **Requirement**: Retrieve the following data from HealthKit:
  - **Heart Rate** (`HKQuantityTypeIdentifier.heartRate`): Periodically fetch current heart rate.
  - **Step Count** (`HKQuantityTypeIdentifier.stepCount`): Retrieve daily step count.
  - **Active Calories Burned** (`HKQuantityTypeIdentifier.activeEnergyBurned`): Retrieve daily active calories burned.
- **Triggers**: Data retrieval may occur in response to user actions or at defined intervals.

##### 2.1.2 Daily Summary Data Aggregation
- **Requirement**: Aggregate and send daily summaries of step count and calories burned at the end of each day.
- **Transmission**: Summarized data will be transmitted to the VitalEdge Data Aggregator.

##### 2.1.3 Real-Time Data for IoT Endpoint
- **Requirement**: Configure periodic heart rate data transmission to an IoT endpoint for real-time monitoring.
- **Interval Setting**: Configurable transmission interval (e.g., every 5 minutes).

---

#### 2.2 Data Transmission

##### 2.2.1 Central Aggregator Transmission
- **Endpoint**: Send daily summaries (step count, calories burned) to the **VitalEdge Data Aggregator** via HTTPS.
- **Payload Format**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "stepCount": 1000,
      "caloriesBurned": 200
  }
  ```

##### 2.2.2 IoT Heart Rate Endpoint
- **Endpoint**: Transmit real-time heart rate to a dedicated **IoT endpoint**.
- **Payload Format**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "heartRate": 75
  }
  ```
- **Transmission Interval**: Configurable in settings (default is every 5 minutes).

---

#### 2.3 Configuration Interface

##### 2.3.1 Configuration Screen
- **Requirement**: Provide a user interface to configure settings for data transmission and real-time monitoring.
- **UI Elements**:
  - **Stepper** for IoT transmission interval (1 to 60 minutes).
  - **Toggle** switches for enabling/disabling:
    - Real-time monitoring (heart rate to IoT endpoint).
    - Daily summaries (step count and calories burned).

##### 2.3.2 Persistence of Settings
- **Requirement**: Persist configuration settings using `UserDefaults`.
- **Stored Settings**:
  - IoT transmission interval
  - Real-time monitoring toggle
  - Daily summary toggle

---

#### 2.4 Data Security and Privacy

##### 2.4.1 Health Data Permissions
- **Requirement**: Request appropriate HealthKit permissions to access health data in accordance with Apple’s HealthKit guidelines.
- **Data Types**:
  - Heart Rate, Step Count, Active Calories Burned

##### 2.4.2 Secure Transmission
- **Requirement**: Transmit data over HTTPS to ensure security during data transfer.
- **Future Scope**: Add AES-256 encryption for sensitive data transmission if required.

---

### 3. Non-Functional Requirements

#### 3.1 Usability
- **User-Friendly UI**: Ensure that the configuration screen is easy to navigate and understand.
- **Minimal User Interaction**: After initial setup, the app should function with minimal user intervention, only requiring adjustments when needed.

#### 3.2 Reliability
- **Error Handling**: The app should provide informative error messages and retry mechanisms for network failures.
- **Data Validation**: Validate each data payload before transmission to ensure completeness and correctness.

#### 3.3 Performance
- **Real-Time Transmission**: Ensure low-latency data transmission for real-time heart rate updates.
- **Efficient Data Aggregation**: Aggregate daily data efficiently to minimize power consumption and API usage.

#### 3.4 Maintainability
- **Modular Code Structure**: Maintain a modular architecture to enable easy updates, such as adding new data types or additional endpoints.
- **Configurable Endpoints**: Implement flexible endpoints for future expansion.

#### 3.5 Privacy
- **HealthKit Compliance**: Comply with Apple’s HealthKit privacy requirements, including user consent and data transparency.
- **Data Deletion**: Allow users to clear stored settings and revoke HealthKit permissions if they choose to discontinue use.

---

### 4. Future Requirements and Extensions

#### 4.1 Additional Health Metrics
- **Future Data Types**: Extend data collection to include additional metrics (e.g., sleep analysis, respiratory rate) as available and permitted by HealthKit.

#### 4.2 Integration with VitalEdge IoT Edge (Raspberry Pi)
- **Objective**: Configure the iOS app to transmit specific data to the VitalEdge IoT edge device for real-time alerting and edge-based processing.
  
#### 4.3 End-to-End Data Security
- **Encryption**: Implement AES-256 encryption for added data security.
- **Authentication**: Introduce user authentication to validate transmissions within the VitalEdge ecosystem.

#### 4.4 External Data Enhancements
- **Location-Based Data**: Integrate optional location data to enrich health metrics with contextual information (e.g., weather conditions).

---

### 5. Assumptions and Dependencies

#### 5.1 Assumptions
- Users will have compatible iOS devices and allow necessary HealthKit permissions.
- Network connectivity is available for transmitting data to endpoints.

#### 5.2 Dependencies
- Apple’s HealthKit framework and required permissions.
- HTTPS connectivity for secure data transmission.
- The VitalEdge Data Aggregator and IoT endpoint infrastructure.

---

### 6. Appendices

#### 6.1 Sample API Payloads

- **VitalEdge Data Aggregator**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "stepCount": 1000,
      "caloriesBurned": 200
  }
  ```

- **IoT Heart Rate Endpoint**:
  ```json
  {
      "userId": "501",
      "timestamp": "2024-11-07T12:34:58Z",
      "heartRate": 75
  }
  ```
