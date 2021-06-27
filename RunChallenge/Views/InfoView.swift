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
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                // header
                VStack {
                    ZStack(alignment: .topLeading) {
                        Image("infoViewHeader16-9")
                            .resizable()
                            .scaledToFit()
                            .overlay(ImageOverlay().opacity(0.3))
                        // headline / closebutton / text
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Run Challenge")
                                        .font(.system(.largeTitle, design: .default))
                                        .fontWeight(.black)
                                }
                                .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    isPresented = false
                                }, label: {
                                    Image(systemName: "chevron.down.circle.fill")
                                        .foregroundColor(Color.white)
                                        .font(.largeTitle)
                                })
                            }
                            .padding(20)
                        }
                    }
                }
               
                VStack {
                    Text("Run Challenge was developed by Moritz Haist. If you like this app you can support me by writing a review or leave a tip.")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(20)
                    
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "dollarsign.circle", linkName: "Buy me a coffee")
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "star", linkName: "Write a review")
                }
                Spacer()
                HStack {
                    Text("Further Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(20)
                    Spacer()
                }
 
                VStack {
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "envelope", linkName: "Support, Bug Report")
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "icloud", linkName: "RunChallenge on Github")
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "globe", linkName: "Contact")
                    CustomLink(linkUrl: "www.bildstrich.net", linkIcon: "app.badge", linkName: "Version 0.0.1")
                }
                Spacer()
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
    }
}

struct CustomLink: View {
    var linkUrl: String
    var linkIcon: String
    var linkName: String
    var body: some View {
        VStack {
            Link(destination: URL(string: linkUrl)!) {
                HStack {
                    Image(systemName: linkIcon)
                        .padding(.trailing)
                        .font(.title)
                    Text(linkName)
                    Spacer()
                    Image(systemName: "chevron.right.circle")
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255))
                .cornerRadius(15)
            }
        }
    }
}
