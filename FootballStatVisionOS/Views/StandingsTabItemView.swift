//
//  StandingsTabItemView.swift
//  FootballStatVisionOS
//
//  Created by Ruben Granet on 12/07/2024.
//

import SwiftUI
import XCAFootballDataClient

struct StandingsTabItemView: View {
    @State var selectedCompetition: Competition?
    
    var body: some View {
        NavigationSplitView {
            List(Competition.defaultCompetitions, id: \.self, selection: $selectedCompetition) {
                Text($0.name)
                    .bold()
            }
            .navigationTitle("Competitions")
        } detail: {
            if let selectedCompetition {
                StandingsTableView(competition: selectedCompetition)
                    .id(selectedCompetition)
            } else {
                Text("Select a competition")
            }
        }
    }
}

#Preview {
    StandingsTabItemView()
}
