# Vision Document

**Project**: VitalEdge Kit - iOS  
**Version**: 1.0  
**Date**: [Date]  
**Author**: Sam Seatt, Team: Xmed

This **Vision Document** defines the objectives, architecture, and future directions for VitalEdge Kit - iOS. It outlines a scalable and secure foundation that aligns with the VitalEdge ecosystem’s goals, allowing for future expansion and modularity in response to healthcare needs.

---

### 1. Introduction

#### 1.1 Purpose
The purpose of VitalEdge Kit - iOS is to act as a health data bridge between users’ Apple devices (iPhone and Apple Watch) and the broader VitalEdge ecosystem, capturing vital health metrics and seamlessly integrating them into the system. By leveraging Apple’s HealthKit, VitalEdge Kit - iOS enables real-time health monitoring and periodic data summaries, facilitating personalized healthcare and wellness insights for both users and healthcare providers.

#### 1.2 Vision Statement
VitalEdge Kit - iOS will provide users with a robust, secure, and user-friendly application that tracks and transmits personal health data. It will empower users to take a proactive role in monitoring their health metrics, facilitating a collaborative healthcare experience, and contributing valuable real-time data to the VitalEdge ecosystem for insights, analysis, and personalized recommendations.

#### 1.3 Scope
VitalEdge Kit - iOS integrates with HealthKit to capture health metrics, transmit selected data to central and IoT endpoints, and offer configurable monitoring and reporting settings. Core functionality includes real-time heart rate transmission, daily summaries, and customizable settings for data transmission intervals and monitoring options. This scope enables a flexible foundation that can grow with future enhancements and data types.


### 2. Key Objectives

1. **Real-Time Patient Monitoring**:
   - Capture and transmit heart rate data at configurable intervals for real-time monitoring by the IoT endpoint, supporting immediate response to critical health events.

2. **Daily Health Summary**:
   - Collect and aggregate daily health data, such as step count and calories burned, sending summaries to the central VitalEdge Data Aggregator for trend analysis and personalized insights.

3. **User-Centric Configuration**:
   - Provide a settings interface allowing users to adjust data transmission intervals, enable or disable real-time monitoring, and configure daily summary reports.

4. **Data Privacy and Security**:
   - Ensure compliance with Apple’s HealthKit privacy standards, enabling user control over data permissions, secure transmission, and optional end-to-end encryption for sensitive health data.

5. **Modularity and Scalability**:
   - Design a modular system to allow the easy addition of new health metrics, endpoints, and future features, facilitating growth in alignment with the VitalEdge ecosystem’s evolving needs.


### 3. Core Functionalities

1. **Health Data Collection and Aggregation**:
   - **Heart Rate**: Retrieve the latest heart rate readings periodically.
   - **Step Count**: Aggregate daily step count.
   - **Calories Burned**: Retrieve daily active calories burned.

2. **Configurable Data Transmission**:
   - **Real-Time Monitoring**: Send heart rate data to the IoT endpoint at user-defined intervals.
   - **Daily Summary**: Aggregate and send daily health metrics to the central VitalEdge Data Aggregator.

3. **User Interface and Settings**:
   - Provide a configuration screen to manage real-time monitoring, daily summary settings, and IoT transmission intervals.
   - Allow users to access and adjust HealthKit permissions directly from the app.

4. **Data Security and Privacy**:
   - Securely transmit all health data over HTTPS and ensure compliance with Apple’s HealthKit privacy requirements.
   - Store user preferences in `UserDefaults` with optional end-to-end encryption for sensitive data.


### 4. Success Criteria

The project will be considered successful if it meets the following criteria:

1. **HealthKit Data Integration**:
   - The app successfully retrieves heart rate, step count, and calorie data, with user permissions properly managed according to HealthKit standards.

2. **Configurable Transmission**:
   - Users can set transmission intervals and enable or disable data feeds. Configurable intervals should successfully drive periodic data transmission.

3. **IoT and Central Aggregator Connectivity**:
   - Data is reliably transmitted to the central aggregator and IoT endpoint in the expected formats, with successful reception logs confirming connectivity.

4. **Data Security and Privacy Compliance**:
   - Health data is securely transmitted, and data handling complies with Apple’s HealthKit privacy guidelines. User settings are persistently stored with full control over HealthKit permissions.


### 5. Design and Technical Overview

#### 5.1 System Architecture
The architecture of VitalEdge Kit - iOS is modular and layered:

1. **HealthKit Integration Layer**:
   - Manages data collection, access permissions, and health metric retrieval.

2. **Data Transmission Layer**:
   - Handles connectivity with the VitalEdge Data Aggregator and IoT endpoint, managing network requests, JSON payloads, and retry mechanisms.

3. **Configuration and User Interface Layer**:
   - Presents users with configuration settings and health metric dashboards (planned), providing seamless interaction with core functionalities.

4. **Data Security and Persistence Layer**:
   - Manages `UserDefaults` for storing configuration settings, supporting secure transmission protocols and compliance with privacy standards.


### 6. Technical Components and Integration

#### 6.1 HealthKit Data Collection
- **Required HealthKit Permissions**: Heart rate, step count, calories burned.
- **APIs**:
  - `fetchLatestHeartRate()`: Retrieves the latest heart rate.
  - `fetchStepCount(for date: Date)`: Aggregates step count for a given date.
  - `fetchActiveCaloriesBurned(for date: Date)`: Aggregates active calories for a given date.

#### 6.2 Data Transmission and API Integration
- **Endpoints**:
  - **VitalEdge Data Aggregator** (`/api/healthkit`): Receives daily summaries.
  - **IoT Endpoint** (`/api/iot-heart-rate`): Receives real-time heart rate data.

#### 6.3 User Interface and Settings
- **Configuration Screen**:
  - Allows users to set IoT transmission intervals and toggle real-time and daily summary options.
  - Provides clear prompts for HealthKit permissions.

#### 6.4 Data Security
- **Transmission Protocols**: All transmissions use HTTPS.
- **Future Enhancements**: End-to-end AES-256 encryption for sensitive data.


### 7. Future Extensions

1. **Additional Health Metrics**:
   - Extend HealthKit data collection to include sleep analysis, respiratory rate, and other relevant metrics, expanding insights within the VitalEdge ecosystem.

2. **Advanced Edge Processing**:
   - Implement additional features on the IoT endpoint to enable critical alerting and data processing at the edge, leveraging real-time metrics for immediate response.

3. **User Authentication and Access Control**:
   - Introduce authentication to validate data integrity and ensure secure access to the VitalEdge ecosystem.

4. **Background Data Fetching**:
   - Utilize `BackgroundTasks` to support data fetching and transmission in the background, providing uninterrupted monitoring and tracking.

5. **Push Notifications**:
   - Implement notifications for health alerts or daily summaries, keeping users informed of critical health events or activity summaries.

6. **Enhanced Data Privacy**:
   - Enable optional data encryption at rest and implement user authentication for access to health data.


### 8. Constraints and Dependencies

#### 8.1 System Requirements
- **iOS Compatibility**: Requires iOS 16.4 or later.
- **Device Requirements**: Best functionality is achieved with Apple Watch and iPhone.

#### 8.2 Dependencies
- **Apple HealthKit**: Health data access requires HealthKit integration.
- **Internet Connectivity**: Necessary for data transmission to external endpoints.
- **VitalEdge Aggregator and IoT Endpoint**: VitalEdge system endpoints must be operational and accessible.


### 9. Assumptions

1. Users will provide HealthKit permissions for data access.
2. Network connectivity will be available for transmitting health data to endpoints.
3. The IoT endpoint will be configured to handle data transmission and execute real-time processing for health alerts if applicable.


### 10. Glossary

- **HealthKit**: Apple’s health data framework.
- **VitalEdge Data Aggregator**: Central server receiving daily summaries.
- **IoT Endpoint**: An endpoint designed to receive real-time heart rate data.
- **HKQuantityTypeIdentifier**: HealthKit identifiers for specific health metrics (e.g., heart rate, step count).
