//
//  FootballStatVisionOSApp.swift
//  FootballStatVisionOS
//
//  Created by Ruben Granet on 09/07/2024.
//

import SwiftUI

@main
struct FootballStatVisionOSApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StandingsTabItemView()
                    .tabItem { Label("Competition", systemImage: "table.fill") }
                
                TopScorersTabItemView()
                    .tabItem { Label("Top Scorers", systemImage: "soccerball.inverse") }
            }
        }
    }
}
