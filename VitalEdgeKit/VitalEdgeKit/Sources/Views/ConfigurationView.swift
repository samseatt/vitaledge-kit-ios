//
//  ConfigurationView.swift
//  VitalEdgeKit
//
//  Created by Sam Seatt on 2024-11-14.
//

import Foundation
import SwiftUI

struct ConfigurationView: View {
    @AppStorage("iotTransmissionInterval") private var iotTransmissionInterval: Double = 5 // in minutes
    @AppStorage("realTimeMonitoringEnabled") private var realTimeMonitoringEnabled: Bool = false
    @AppStorage("dailySummaryEnabled") private var dailySummaryEnabled: Bool = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("IoT Data Transmission")) {
                    Stepper(value: $iotTransmissionInterval, in: 1...60, step: 1) {
                        Text("Interval: \(Int(iotTransmissionInterval)) minutes")
                    }
                    .padding()
                }
                
                Section(header: Text("Monitoring Options")) {
                    Toggle("Enable Real-Time Monitoring", isOn: $realTimeMonitoringEnabled)
                    Toggle("Enable Daily Summary", isOn: $dailySummaryEnabled)
                }
            }
            .navigationTitle("Configuration")
        }
    }
}
