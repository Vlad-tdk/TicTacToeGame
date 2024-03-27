//
//  AI.swift
//  TicTacToeGame
//
//  Created by Vlad on 27.3.24..
//

import Foundation

// Класс AI представляет искусственный интеллект для игры в крестики-нолики
class AI {
    
    // Метод minimax реализует алгоритм минимакс для поиска оптимального хода
    func minimax(board: Board, depth: Int, isMaximizing: Bool) -> Int {
        if board.isWinning(player: .circle) {
            return 1
        }
        if board.isWinning(player: .cross) {
            return -1
        }
        if board.isFull() {
            return 0
        }
        
        if isMaximizing {
            var bestScore = Int.min
            let moves = board.availableMoves()
            for move in moves {
                let newBoard = board.copy() // Создаем копию доски
                newBoard.makeMove(move, player: .circle)
                let score = minimax(board: newBoard, depth: depth + 1, isMaximizing: false)
                bestScore = max(score, bestScore)
            }
            return bestScore
        } else {
            var bestScore = Int.max
            let moves = board.availableMoves()
            for move in moves {
                let newBoard = board.copy() // Создаем копию доски
                newBoard.makeMove(move, player: .cross)
                let score = minimax(board: newBoard, depth: depth + 1, isMaximizing: true)
                bestScore = min(score, bestScore)
            }
            return bestScore
        }
    }
    
    // Метод findBestMove использует алгоритм минимакс для поиска наилучшего хода
    func findBestMove(board: Board) -> Move {
        var bestScore = Int.min
        var bestMove = Move(row: -1, col: -1)
        let moves = board.availableMoves()
        
        // Проходим по всем доступным ходам
        for move in moves {
            let newBoard = board.copy() // Создаем копию доски
            newBoard.makeMove(move, player: .circle)
            let score = minimax(board: newBoard, depth: 0, isMaximizing: false)
            
            // Обновляем наилучший ход и его оценку
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }
        return bestMove // Возвращаем лучший найденный ход
    }
}
