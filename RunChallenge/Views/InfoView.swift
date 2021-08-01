//
//  InfoView.swift
//  RunChallenge
//
//  Created by Moritz Haist on 22.06.21.
//

import SwiftUI
import StoreKit

struct InfoView: View {
    
    @Binding var isPresented: Bool
    //data for sending email
    @State private var mailData = ComposeMailData(subject: "[RunChallenge App]", recipients: ["runchallengeapp@bildstrich.net"], message: "", attachments: [])
    @State private var showMailView = false
    
    @ObservedObject var products = ProductsDB.shared
    
    func leaveTip() {
        let _ = IAPManager.shared.purchase(product: self.products.items[0])
    }
    
    func askForRating() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
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
                ScrollView {
                    VStack {
                        Text("Run Challenge was developed by Moritz Haist. If you like this app you can support my work by writing a review or leave a tip.")
                            .font(.body)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(20)
                    }
                    VStack {
                        // buttons with custom actions
                        CustomButton(buttonIcon: "eurosign.circle", buttonLabel: "Buy me a coffee", buttonArrow: false, buttonText: "1,09 €", buttonFunction: self.leaveTip)
                            .onAppear {
                                IAPManager.shared.getProducts()
                            }
                        CustomButton(buttonIcon: "star", buttonLabel: "Rate and review this app", buttonArrow: true, buttonText: nil, buttonFunction: self.askForRating)
                        // button for Mail View
                        VStack {
                            Button(action: {
                                showMailView.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "paperplane")
                                        .padding(.trailing)
                                    Text("Support, Bug Report")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .disabled(!MailView.canSendMail)
                                .sheet(isPresented: $showMailView) {
                                    MailView(data: $mailData) { result in
                                        print(result)
                                    }
                                }
                                .modifier(ctaModifier())
                            })
                        }
                        .padding(.horizontal, 20)
                        // links with external targets
                        CustomLink(linkUrl: "https://github.com/moritzhaist", linkIcon: "applescript", linkName: "RunChallenge on Github")
                        CustomLink(linkUrl: "https://linktr.ee/moritzhaist", linkIcon: "message", linkName: "Contact")
                        // app version info
                        HStack {
                            Image(systemName: "app.badge")
                                .padding(.trailing)
                            Text("Version 1.0.0 beta 3")
                            Spacer()
                        }
                        .modifier(ctaModifier())
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
            .environment(\.locale, .init(identifier: "de"))
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
                    
                    Text(LocalizedStringKey(linkName))
                    Spacer()
                    Image(systemName: "chevron.right")                }
                    .modifier(ctaModifier())
            }
        }
        .padding(.horizontal, 20)
    }
}

struct CustomButton: View {
    var buttonIcon: String
    var buttonLabel: String
    var buttonArrow: Bool
    var buttonText: String?
    var buttonFunction: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                self.buttonFunction()
            }, label: {
                HStack {
                    Image(systemName: buttonIcon)
                        .padding(.trailing)
                    
                    Text(LocalizedStringKey(buttonLabel))
                    Spacer()
                    if buttonText != nil {
                        Text(buttonText!)
                    }
                    if buttonArrow {
                        Image(systemName: "chevron.right")
                    }
                }
                .modifier(ctaModifier())
            })
        }
        .padding(.horizontal, 20)
        
    }
}

struct ctaModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(15)
            .background(Color("mDarkColor"))
            .cornerRadius(15)
    }
}
