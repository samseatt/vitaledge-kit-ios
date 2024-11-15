//
//  MockHealthKitService.swift
//  VitalEdgeKit
//
//  Created by Sam Seatt on 2024-11-14.
//
import Foundation

class MockHealthKitService: HealthKitServiceProtocol {
    func fetchLatestHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        let mockedHeartRate = Double.random(in: 60...100) // Generate a random heart rate value for each call
        completion(mockedHeartRate, nil)
    }
    
    func fetchStepCount(for date: Date, completion: @escaping (Double?, Error?) -> Void) {
        completion(7500, nil)  // Mocked step count for testing
    }
    
    func fetchActiveCaloriesBurned(for date: Date, completion: @escaping (Double?, Error?) -> Void) {
        completion(500, nil)  // Mocked calories burned for testing
    }

}
