//
//  InfoView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 22.06.21.
//

import SwiftUI

struct InfoView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
    }
}
