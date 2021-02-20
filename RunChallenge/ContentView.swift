//
//  ContentView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 20.02.21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("sumOfRuns") var sumOfRuns = 0.00
    
    var body: some View {
        Text(" \(String(format: "%.3f", sumOfRuns)) KM")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
