//
//  File.swift
//  RunChallenge
//
//  Created by Moritz Haist on 14.03.21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var currentChallenge: Double
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Spacer()
            Text("\(String(format: "%.0f", currentChallenge)) KM")
                .font(.system(size: 30.0, weight: .black, design: .default))
                .padding(30)
            Spacer()
            Text("Wieviel willst du diesen Monat schaffen?")
            Slider(value: $currentChallenge, in: 0...300, step: 1)
                .padding(20)
            Button("Los!", action: {self.updateChallenge()} )
        }
    }
    func updateChallenge() {
        let newChallenge = currentChallenge
        UserDefaults(suiteName: "group.com.bildstrich.net.RunChallenge")!.set(newChallenge, forKey: "distanceChallenge")
        isPresented = false
    }
}
