//
//  StandingsTableView.swift
//  FootballStatVisionOS
//
//  Created by Ruben Granet on 09/07/2024.
//

import SwiftUI
import XCAFootballDataClient
import SDWebImage
import SDWebImageSwiftUI

struct StandingsTableView: View {
    
    let competition: Competition
    @Bindable var viewModel = StandingsTableObservable()
    
    var body: some View {
        Table(of: TeamStandingTable.self) {
            
            TableColumn("Club") { team in
                HStack {
                    Text(team.positionText)
                        .fontWeight(.bold)
                        .frame(minWidth: 20)
                    
                    if let crest = team.team.crest, crest.hasSuffix("svg") {
                        WebImage(url: URL(string: crest), options: .delayPlaceholder, content: { image in
                            image
                                .resizable()
                        }, placeholder: {
                            Circle()
                                .foregroundStyle(Color.blue.opacity(0.5))
                        })
                        .frame(width: 40, height: 40)
                    } else {
                        AsyncImage(url: URL(string: team.team.crest ?? "")) { phase in
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
                    
                    Text(team.team.name)
                        .fontWeight(.bold)
                        .padding()
                }
            }
            .width(min: 264)
            
            TableColumn("W") { Text($0.wonText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("D") { Text($0.drawText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("L") { Text($0.lostText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("GF") { Text($0.goalsForText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("GA") { Text($0.goalsAgainstText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("GD") { Text($0.goalDifferenceText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("Pts") { Text($0.pointsText).frame(minWidth: 40)}
                .width(50)
            
            TableColumn("Last 5") { club in
                HStack(spacing: 4, content: {
                    if let formArray = club.formArray, !formArray.isEmpty {
                        ForEach(formArray, id: \.self) { form in
                            switch form {
                                case "W":
                                    Image(systemName: "checkmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.white, Color.green)
                                case "L":
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.white, Color.red)
                                    
                                default:
                                    Image(systemName: "minus.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.white, Color.white.opacity(0.5))
                            }
                        }
                    } else {
                        Text("-")
                            .frame(width: 120, alignment: .center)
                    }
                })
            }
            .width(120)
        } rows: {
            ForEach(viewModel.standings ?? []) {
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
        .navigationTitle(competition.name)
        .task(id: viewModel.selectedFilter.id) {
            await viewModel.fetchStandings(competition: competition)
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
        StandingsTableView(competition: .defaultCompetitions[1])
    }
}
