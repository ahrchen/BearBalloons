//
//  BearBalloonApp.swift
//  BearBalloon
//
//  Created by Raymond Chen on 1/16/24.
//

import SwiftUI

@main
struct BearBalloonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 100, height: 100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
