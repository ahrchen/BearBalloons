//
//  ContentView.swift
//  BearBalloon
//
//  Created by Raymond Chen on 1/16/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack {
            Text("Bear Balloon!")
        }
        .padding()
        .task {
            await openImmersiveSpace(id: "ImmersiveSpace")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
