//
//  RunChallengeApp.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI

@main
struct RunChallengeApp: App {
    
    init() {
        print("init RunChallengeApp")
        // Authorize Healthkit
        HealthKitSetup.authorizeHealthKit() { (authorized, error) in
            guard authorized else {
                let errorMessage = "HealthKit Authorization failed"
                if let error = error {
                    print("\(errorMessage): \(error.localizedDescription)")
                } else {
                    print(errorMessage)
                }
                return
            }
            print("HealthKit successful authorized")
            HealthKitQuery.startObservingWorkoutChanges()
            
            // Temporally store monthly challenge value - this has to be handled with userinput
            let distanceChallenge: Double = 200
            UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(distanceChallenge, forKey: "distanceChallenge")

        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(workoutData: WorkoutData())
        }
    }
}
