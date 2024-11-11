//
//  ContentView.swift
//  tictac
//  B.RF Group
//
import SwiftUI

struct MainS: View {
    @StateObject var gameManager = GameManager()
    
    var body: some View {
        if gameManager.showGame {
            GridS()
                .environmentObject(gameManager)
                .environmentObject(GridVM(gameManager: gameManager))
        } else {
            GameSettingsS()
                .environmentObject(gameManager)
        }
    }
}

#Preview {
    MainS()
}
