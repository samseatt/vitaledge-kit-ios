//
//  HealthKitServiceProtocol.swift
//  VitalEdgeKit
//
//  Created by Sam Seatt on 2024-11-14.
//
import Foundation

protocol HealthKitServiceProtocol {
    func fetchLatestHeartRate(completion: @escaping (Double?, Error?) -> Void)
    func fetchStepCount(for date: Date, completion: @escaping (Double?, Error?) -> Void)
    func fetchActiveCaloriesBurned(for date: Date, completion: @escaping (Double?, Error?) -> Void)
}
