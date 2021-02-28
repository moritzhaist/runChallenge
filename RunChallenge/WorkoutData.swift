//
//  WorkoutData.swift
//  RunChallenge
//
//  Created by Moritz Haist on 28.02.21.
//

import SwiftUI

class WorkoutData: ObservableObject {
    
    @AppStorage("sumOfRuns", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var sumOfRuns: Double = 0.00
    
    @AppStorage("distanceChallenge", store: UserDefaults(suiteName:"group.com.bildstrich.net.RunChallenge"))
    var distanceChallenge: Double = 0.00
    
    func getSumOfRuns() -> Double {
        return sumOfRuns
    }
    
    func getDistanceChallenge() -> Double {
        return distanceChallenge
    }
    
    func getProgress() -> Double {
        return sumOfRuns / distanceChallenge
    }
    
}
