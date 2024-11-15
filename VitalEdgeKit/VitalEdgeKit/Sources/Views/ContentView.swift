//
//  ContentView.swift
//  VitalEdgeKit
//
//  Created by Sam Seatt on 2024-11-13.
//
import SwiftUI
import Foundation
import Combine

let healthKitService: HealthKitServiceProtocol = {
    #if targetEnvironment(simulator)
    return MockHealthKitService()
    #else
    return HealthKitService()
    #endif
}()

struct ContentView: View {
    @State private var heartRate: Double?
    @State private var errorMessage: String?
    @AppStorage("iotTransmissionInterval") private var iotTransmissionInterval: Double = 5
    @AppStorage("realTimeMonitoringEnabled") private var realTimeMonitoringEnabled: Bool = false
    @AppStorage("dailySummaryEnabled") private var dailySummaryEnabled: Bool = true

    // Publisher for IoT transmission timer
    private var iotTimer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: iotTransmissionInterval * 60, on: .main, in: .common).autoconnect()
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("VitalEdge HealthKit Demo")
                    .font(.title)
                    .padding()
                
                if let heartRate = heartRate {
                    Text("Latest Heart Rate: \(heartRate, specifier: "%.1f") BPM")
                        .font(.headline)
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("No heart rate data available.")
                        .padding()
                }
                
                NavigationLink("Go to Configuration", destination: ConfigurationView())
                    .padding()
                
                Button("Send Daily Summary") {
                    sendDailySummary()
                }
                .padding()
                
                Button("Send Heart Rate to IoT Endpoint") {
                    fetchAndSendHeartRateToIoT()
                }
                .padding()
            }
        }
        .onReceive(iotTimer) { _ in
            if realTimeMonitoringEnabled {
                fetchAndSendHeartRateToIoT()
            }
        }
    }

//            Button("Send Heart Rate to IoT Endpoint") {
//                healthKitService.fetchLatestHeartRate { result, error in
//                    DispatchQueue.main.async {
//                        if let error = error {
//                            self.errorMessage = error.localizedDescription
//                            self.heartRate = nil
//                        } else if let result = result {
//                            self.heartRate = result
//                            self.errorMessage = nil
//
//                            // Construct JSON data for IoT endpoint
//                            let jsonData: [String: Any] = [
//                                "userId": "501",
//                                "timestamp": ISO8601DateFormatter().string(from: Date()),
//                                "heartRate": Int(result)  // Cast to Int for endpoint compatibility
//                            ]
//                            self.sendDataToIoTEndpoint(with: jsonData)
//                        } else {
//                            self.heartRate = nil
//                            self.errorMessage = "No heart rate data available."
//                        }
//                    }
//                }
//            }
//            .padding()
//
//            Button("Send Daily Summary") {
//                sendDailySummary()
//            }
//            .padding()
//
//        }
//    }

    func fetchHeartRate() {
        healthKitService.fetchLatestHeartRate { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.heartRate = nil
                } else if let result = result {
                    self.heartRate = result
                    self.errorMessage = nil
                    let jsonData: [String: Any] = [
                        "userId": "501",
                        "timestamp": ISO8601DateFormatter().string(from: Date()),
                        "heartRate": Int(result)                // Example for heart rate
                    ]
                    self.sendDataToAPI(with: jsonData)
                } else {
                    self.heartRate = nil
                    self.errorMessage = "No heart rate data available."
                }
            }
        }
    }

    // This function will format the data in JSON and send it to the endpoint specified.
    /*
     URL: The function connects to http://localhost:3000/api/healthkit, the endpoint you specified.
     Timestamp: We generate a unique timestamp with ISO8601DateFormatter to ensure each data point is unique.
     JSON Data: We prepare the data with a sample userId, timestamp, stepCount, and caloriesBurned values. You can replace stepCount and caloriesBurned values as needed.
     Request Execution: We use URLSession to send the HTTP POST request and log the result.
     */
    func sendDataToAPI(with jsonData: [String: Any]) {
        guard let url = URL(string: "http://localhost:3000/api/healthkit") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            if let jsonString = String(data: requestData, encoding: .utf8) {
                print("JSON Payload: \(jsonString)")
            }
            request.httpBody = requestData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        print("Sending request to URL: \(url)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Data sent successfully!")
            } else {
                print("Failed to send data: \(String(describing: response))")
            }
        }
        task.resume()
    }


    
//    func sendDataToAPI(heartRate: Double) {
//        guard let url = URL(string: "http://localhost:3000/api/healthkit") else {
//            print("Invalid URL")
//            return
//        }
//
//        // Create the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Generate a unique timestamp for each request
//        let timestamp = ISO8601DateFormatter().string(from: Date())
//
//        // Prepare JSON data, including the heartRate value
//        let jsonData: [String: Any] = [
//            "userId": "501",                      // Update to match your sample payload
//            "timestamp": timestamp,               // Unique timestamp
//            "stepCount": 1001,                    // Matching your sample step count
//            "caloriesBurned": 201,                // Matching your sample calories burned
//            "heartRate": Int(heartRate)           // Heart rate value from HealthKit or mock service
//        ]
//
//        // Print the JSON payload to ensure it matches the expected format
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
//            if let jsonString = String(data: requestData, encoding: .utf8) {
//                print("JSON Payload: \(jsonString)")
//            }
//            request.httpBody = requestData
//        } catch {
//            print("Error serializing JSON: \(error)")
//            return
//        }
//
//        // Print the full request details
//        print("Sending request to URL: \(url)")
//        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
//        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
//            print("Request Body: \(bodyString)")
//        }
//
//        // Send the request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error sending data: \(error)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                print("Data sent successfully!")
//            } else {
//                print("Failed to send data: \(String(describing: response))")
//            }
//        }
//        task.resume()
//    }

    func sendDataToIoTEndpoint(with jsonData: [String: Any]) {
        guard let url = URL(string: "http://localhost:3000/api/iot-heart-rate") else {
            print("Invalid IoT URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = requestData
            if let jsonString = String(data: requestData, encoding: .utf8) {
                print("IoT JSON Payload: \(jsonString)")
            }
        } catch {
            print("Error serializing JSON for IoT: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data to IoT endpoint: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Data sent successfully to IoT endpoint!")
            } else {
                print("Failed to send data to IoT endpoint: \(String(describing: response))")
            }
        }
        task.resume()
    }

    
    func sendDailySummary() {
        let date = Date()
        
        // Fetch step count
        healthKitService.fetchStepCount(for: date) { stepCount, stepError in
            guard let stepCount = stepCount, stepError == nil else {
                print("Error fetching step count: \(String(describing: stepError))")
                return
            }

            // Fetch calories burned
            healthKitService.fetchActiveCaloriesBurned(for: date) { caloriesBurned, caloriesError in
                guard let caloriesBurned = caloriesBurned, caloriesError == nil else {
                    print("Error fetching calories burned: \(String(describing: caloriesError))")
                    return
                }
                
                // Send the daily summary data to the API
                let timestamp = ISO8601DateFormatter().string(from: date)
                let jsonData: [String: Any] = [
                    "userId": "501",
                    "timestamp": timestamp,
                    "stepCount": Int(stepCount),
                    "caloriesBurned": Int(caloriesBurned),
                    "heartRate": 0  // Optionally add a placeholder for heart rate if needed
                ]
                
                sendDataToAPI(with: jsonData)
            }
        }
    }
    
    // Function to fetch and send heart rate to IoT endpoint
    func fetchAndSendHeartRateToIoT() {
        healthKitService.fetchLatestHeartRate { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.heartRate = nil
                } else if let result = result {
                    self.heartRate = result
                    self.errorMessage = nil
                    
                    let jsonData: [String: Any] = [
                        "userId": "501",
                        "timestamp": ISO8601DateFormatter().string(from: Date()),
                        "heartRate": Int(result)
                    ]
                    sendDataToIoTEndpoint(with: jsonData)
                } else {
                    self.heartRate = nil
                    self.errorMessage = "No heart rate data available."
                }
            }
        }
    }


}
