//
//  HealthKitQuery.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import HealthKit

class HealthKitQuery {
    
    class func startObservingWorkoutChanges() {
        print("startObservingWorkoutChanges")
        let sampleType = HKObjectType.workoutType()
        let healthStore = HKHealthStore()
        
        // enable background delivery for workouts
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (success, error) in
            guard success else {
                let errorMessage = "Could not enable background delivery"
                if let error = error {
                    print("\(errorMessage): \(error.localizedDescription)")
                } else {
                    print(errorMessage)
                }
                return
            }
            print("Background delivery enabled!")
        }
        
        // open observer query for workouts
        let observerQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            self.getSumOfRunningWorkoutsDistance { results in
                guard let sumOfRuns = results else {
                    print("There are no results")
                    return
                }
                // Store results in UserDefaults
                UserDefaults.standard.set(sumOfRuns, forKey: "sumOfRuns")
                completionHandler()
            }
        }
        healthStore.execute(observerQuery)
    }
            
    class func getSumOfRunningWorkoutsDistance(completionHandler: @escaping (_ sample: Double?) -> Void) {
        
        print("getSumOfRunningWorkoutsDistance")
        let sampleType = HKObjectType.workoutType()
        let healthStore = HKHealthStore()
        let now = Date()
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: now)
        let startOfMonth = Calendar.current.date(from: comp)!
        let timePredicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: now, options: [])
        let runningWorkouts = HKQuery.predicateForWorkouts(with: .running)
        let combinedPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [runningWorkouts, timePredicate])
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery.init(sampleType: sampleType, predicate: combinedPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortByDate]) { (_, results, error) in
            guard let allRunningWorkouts = results as? [HKWorkout] else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            var listOfDistances = [Double]();
                for run in allRunningWorkouts {
                    let distance = (run.totalDistance!).doubleValue(for: HKUnit.meter())
                    listOfDistances.append(Double(round(distance) / 1000))
                }
            let sumOfRunningWorkoutsDistance = listOfDistances.reduce(0, +)
            print("sumOfRunningWorkoutsDistance: \(sumOfRunningWorkoutsDistance)")

            completionHandler(sumOfRunningWorkoutsDistance)
        }
        healthStore.execute(query)
    }
}

