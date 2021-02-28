//
//  ContentView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var workoutData: WorkoutData
    
    var body: some View {
        ZStack {
            Color.black
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Runtracker Challenge")
                    .foregroundColor(.white)
                ZStack {
                    Circle()
                        .stroke(lineWidth: 30.0)
                        .opacity(0.05)
                        .foregroundColor(Color(red: 32 / 255, green: 148 / 255, blue: 1, opacity: 1))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(workoutData.getProgress(), 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color(red: 32 / 255, green: 148 / 255, blue: 1, opacity: 1))
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear)
                    VStack {
                        Text("KM")
                            .foregroundColor(.white)
                        Text("\(String(format: "%.f", workoutData.getSumOfRuns()))")
                            .foregroundColor(.white)
                        Text("\(String(format: "%.0f", workoutData.getDistanceChallenge()))")
                            .foregroundColor(.white)
                    }
                }
                .padding(50)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(workoutData: WorkoutData())
    }
}
