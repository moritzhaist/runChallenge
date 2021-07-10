//
//  HealthKitSetup.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import HealthKit

class HealthKitSetup {
    
    private enum HealthKitSetupError: Error {
        case HealthKitNotAvailibleOnDevice
        case HealthKitAuthorizationDenied
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> ()) {
        
        let healthStore = HKHealthStore()
        
        // check if Healthkit is availible on device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not availible: \(HealthKitSetupError.HealthKitNotAvailibleOnDevice)")
            completion(false, HealthKitSetupError.HealthKitNotAvailibleOnDevice)
            return
        }
        
        // constant for reading workouts from HealthKit
        let healthKitTypesToRead = Set([HKObjectType.workoutType()])
        
        // request authorization
        healthStore.requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
        
    }
    
}
