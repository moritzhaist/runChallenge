//
//  HealthKitQuery.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import HealthKit
import WidgetKit

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
            // get sum of running workouts for current month
            self.getSumOfRunningWorkoutsDistance(timeInterval: "currentMonth") { results in
                guard let sumOfRunsMonth = results else {
                    print("There are no results")
                    return
                }
                // Store results in UserDefaults
                UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(sumOfRunsMonth, forKey: "sumOfRunsMonth")
                WidgetCenter.shared.reloadAllTimelines()
                completionHandler()
            }
            // get total sum of running workouts for current year
            self.getSumOfRunningWorkoutsDistance(timeInterval: "currentYear") { results in
                guard let sumOfRunsYear = results else {
                    print("There are no results")
                    return
                }
                // Store results in UserDefaults
                UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(sumOfRunsYear, forKey: "sumOfRunsYear")
                completionHandler()
            }
        }
        healthStore.execute(observerQuery)
    }
            
    class func getSumOfRunningWorkoutsDistance(timeInterval: String ,completionHandler: @escaping (_ sample: Double?) -> Void) {
        
        print("getSumOfRunningWorkoutsDistance for \(timeInterval)")
        
        let sampleType = HKObjectType.workoutType()
        let healthStore = HKHealthStore()
        let now = Date()
        var dateComponent = DateComponents()
        
        if timeInterval == "currentMonth" {
            dateComponent = Calendar.current.dateComponents([.year, .month], from: now)
        } else {
            dateComponent = Calendar.current.dateComponents([.year], from: now)
        }
        
        let startOfInterval = Calendar.current.date(from: dateComponent)!
        let timePredicate = HKQuery.predicateForSamples(withStart: startOfInterval, end: now, options: [])
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
            print("sumOfRunningWorkoutsDistance for \(timeInterval): \(sumOfRunningWorkoutsDistance)")

            completionHandler(sumOfRunningWorkoutsDistance)
        }
        healthStore.execute(query)
    }
}

