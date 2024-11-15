//
//  HealthKitService.swift
//  VitalEdgeKit
//
//  Created by Sam Seatt on 2024-11-13.
//

import Foundation
import HealthKit

class HealthKitService: HealthKitServiceProtocol {
    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()
    
    // Define the data types you want to read
    private var healthDataTypes: Set<HKSampleType> {
        return [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]
    }
    
    // Request HealthKit authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: healthDataTypes) { (success, error) in
            completion(success, error)
        }
    }
    
    // Fetch the latest heart rate sample
    
    func fetchLatestHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        print("Fetching real heart rate...")
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Heart rate type not available"]))
            return
        }

        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { (query, results, error) in
            if let error = error {
                completion(nil, error)
            } else if let quantitySample = results?.first as? HKQuantitySample {
                let heartRate = quantitySample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(heartRate, nil)
            } else {
                completion(nil, nil)
            }
        }
        healthStore.execute(query)
    }

    func fetchStepCount(for date: Date, completion: @escaping (Double?, Error?) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step count type not available"]))
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: date), end: date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
            } else if let sum = result?.sumQuantity() {
                let stepCount = sum.doubleValue(for: HKUnit.count())
                completion(stepCount, nil)
            } else {
                completion(nil, nil)
            }
        }
        healthStore.execute(query)
    }

    // Fetch daily active calories burned
    func fetchActiveCaloriesBurned(for date: Date, completion: @escaping (Double?, Error?) -> Void) {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Active energy type not available"]))
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: date), end: date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
            } else if let sum = result?.sumQuantity() {
                let caloriesBurned = sum.doubleValue(for: HKUnit.kilocalorie())
                completion(caloriesBurned, nil)
            } else {
                completion(nil, nil)
            }
        }
        healthStore.execute(query)
    }

    
}

