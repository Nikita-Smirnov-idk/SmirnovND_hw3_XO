//
//  MovesLogic.swift
//  TicTacToeFlexSUI
//
//  Created by Никита Смирнов on 30.10.2024.
//

import SwiftUI

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

class MovesLogic
{
    var winPatterns: Set<Set<Int>> = []
    var isHumansTurn = true
    var moves: [Move?] = Array(repeating: nil, count: 9)
    var boardSize: Int
    
    init(_ size: Int) {
        self.boardSize = size
        self.createWinPatterns()
    }
    
    func changeBoardSize(_ size: Int) {
        self.boardSize = size
        moves = Array(repeating: nil, count: self.boardSize*self.boardSize)
        self.createWinPatterns()
    }
    
    func createWinPatterns() {
        winPatterns = []
        for i in 0...self.boardSize-1 {
            var temp_set_1: Set<Int> = []
            var temp_set_2: Set<Int> = []
            for j in 0...self.boardSize-1 {
                temp_set_1.insert(j + i*self.boardSize)
                temp_set_2.insert(j*self.boardSize + i)
            }
            winPatterns.insert(temp_set_1)
            winPatterns.insert(temp_set_2)
        }
        var temp_count = 0
        var temp_set: Set<Int> = [0]
        for _ in 1...self.boardSize-1 {
            temp_count += self.boardSize + 1
            temp_set.insert(temp_count)
        }
        winPatterns.insert(temp_set)
        
        temp_set = [self.boardSize-1]
        temp_count = self.boardSize-1
        for _ in 1...self.boardSize-1{
            temp_count += self.boardSize - 1
            temp_set.insert(temp_count)
        }
        winPatterns.insert(temp_set)
    }
        
    
    func determineComputerMove(in Move: [Move?]) -> Int {
        // if AI try to win.
        let computerMove = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPosition = Set(computerMove.map { $0.boardIndex })
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            if winPositions.count == 1 {
                let isAvalable = !isCircleOccuped(forIndex: winPositions.first!)
                if isAvalable { return winPositions.first! }
            }
        }
        // if AI cant win, then block
        let humanMove = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMove.map { $0.boardIndex })
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            if winPositions.count == 1 {
                let isAvalable = !isCircleOccuped(forIndex: winPositions.first!)
                if isAvalable { return winPositions.first! }
            }
        }
        // if Ai can't block, take the middle space
        for i in boardSize...boardSize * boardSize-boardSize-1 {
            if !(i % boardSize == 0 || i % boardSize == boardSize-1) {
                if !isCircleOccuped(forIndex: i) { return i }
            }
        }
        // if Ai can't take the middle, tale the corner
        for i in [0, boardSize-1, boardSize*boardSize-boardSize, boardSize*boardSize-1]
        {
            if !isCircleOccuped(forIndex: i) { return i }
        }
        
        // if AI cant take the corner, pick a random spot
        var movePostion = Int.random(in: 0..<(self.boardSize * self.boardSize))
        while isCircleOccuped(forIndex: movePostion) {
            movePostion = Int.random(in: 0..<(self.boardSize * self.boardSize))
        }
        return movePostion
    }
    
    func isCircleOccuped(forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
}
