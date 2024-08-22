//
//  TopScorersTableView.swift
//  FootballStatVisionOS
//
//  Created by Ruben Granet on 12/07/2024.
//

import SwiftUI
import XCAFootballDataClient
import SDWebImageSwiftUI

struct TopScorersTableView: View {
    
    let competition: Competition
    @Bindable var viewModel = TopScorersTableObservable()
    
    var body: some View {
        Table(of: Scorer.self) {
            TableColumn("Pos") { scorer in
                HStack {
                    Text(scorer.posText)
                        .fontWeight(.bold)
                        .frame(minWidth: 20)
                    
                    if let crest = scorer.team.crest, crest.hasSuffix("svg") {
                        WebImage(url: URL(string: crest), options: .delayPlaceholder, content: { image in
                            image
                                .resizable()
                        }, placeholder: {
                            Circle()
                                .foregroundStyle(Color.blue.opacity(0.5))
                        })
                        .frame(width: 40, height: 40)
                    } else {
                        AsyncImage(url: URL(string: scorer.team.crest ?? "")) { phase in
                            switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                default:
                                    Circle()
                                        .foregroundStyle(Color.gray.opacity(0.5))
                            }
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text(scorer.player.name)
                        .fontWeight(.bold)
                        .padding()
                    
                }
            }
            .width(min: 264)
            
            
            TableColumn("Matchs") { Text($0.playedMatchesText).frame(minWidth: 64)}
                .width(80)
            
            TableColumn("Goals") { Text($0.goalsText).frame(minWidth: 64)}
                .width(80)

            TableColumn("Ratio") { Text($0.goalsPerMatchRatioText).frame(minWidth: 64)}
                .width(64)
            
            TableColumn("Penalties") { Text($0.penaltiesText).frame(minWidth: 64)}
                .width(100)
            
            TableColumn("Assists") { Text($0.assistsText).frame(minWidth: 64)}
                .width(80)
            
        } rows: {
            ForEach(viewModel.scorers ?? []) {
                TableRow($0)
            }
        }
        .overlay(content: {
            switch viewModel.fetchPhase {
                case .fetching: ProgressView()
                case .failure(let error):
                    Text(error.localizedDescription)
                        .font(.headline)
                default:
                    EmptyView()
            }
        })
        .foregroundStyle(Color.primary)
        .navigationTitle(competition.name + " Top Scorers")
        .task(id: viewModel.selectedFilter.id) {
            await viewModel.fetchTopScorers(competition: competition)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Picker("Filter Options", selection: $viewModel.selectedFilter) {
                    ForEach(viewModel.filterOptions, id: \.self) { season in
                        Text("\(season.text) ")
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TopScorersTableView(competition: .defaultCompetitions[1])
    }
}
