//
//  GameManager.swift
//  tictac
//  B.RF Group
//
import Foundation
import SwiftUI

class GameManager: ObservableObject
{
    lazy var movesLogic = MovesLogic(self.boardSize)
    @Published var showGame: Bool = false
    @Published var boardSize: Int = 3 {
        didSet{
            movesLogic.createWinPatterns()
            movesLogic.changeBoardSize(self.boardSize)
        }
    }
}
