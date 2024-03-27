//
//  TicTacToeViewModel.swift
//  TicTacToeGame
//
//  Created by Vlad on 27.3.24..
//

import Foundation

// Класс TicTacToeViewModel представляет модель игры крестики-нолики
class TicTacToeViewModel {
    private let board: Board // Доска игры
    private let ai: AI // Искусственный интеллект
    var gameBoard: Board {
        return board
    }
    
    // Текущий игрок (крестик или нолик)
    var currentPlayer: CellState = .cross
    // Инициализатор класса
    init() {
        self.board = Board() // Создаем новую доску
        self.ai = AI() // Создаем экземпляр искусственного интеллекта
    }
    // Метод для совершения хода игроком
    func makeMove(row: Int, col: Int) -> (Int, Int)? {
        // Проверяем, является ли текущий игрок человеком
        guard currentPlayer == .cross else {
            return nil // Если текущий игрок - нолик (AI), выходим из метода
        }
            // Проверяем, является ли ячейка пустой
            if isCellEmpty(row: row, col: col) {
                // Если да, совершаем ход игрока
                board.makeMove(Move(row: row, col: col), player: currentPlayer)
                // Проверяем, выиграл ли игрок
                if board.isWinning(player: currentPlayer) {
                    return (row, col) // Возвращаем позицию выигрышного хода
                }
                return nil // Возвращаем nil, так как выигрышных ходов нет
            }
            return nil // Возвращаем nil, так как нельзя совершить ход в занятую ячейку
        
    }
    // Метод для совершения хода искусственным интеллектом
    func makeAIMove() -> (Int, Int, Bool)? {
        // Проверяем, является ли текущий игрок ноликом (AI)
        guard currentPlayer == .circle else {
            return nil // Если текущий игрок - крестик (человек), выходим из метода
        }
        // Ищем наилучший ход для искусственного интеллекта
        let move = ai.findBestMove(board: board)
        // Выполняем ход на доске
        board.makeMove(move, player: currentPlayer)
        // Проверяем, выиграл ли текущий игрок
        if board.isWinning(player: currentPlayer) {
            return (move.row, move.col, true) // Возвращаем позицию выигрышного хода
        }
        return (move.row, move.col, false) // Возвращаем позицию совершенного хода
    }

    // Проверяет, является ли ячейка пустой
    func isCellEmpty(row: Int, col: Int) -> Bool {
        return board.cells[row][col] == .empty
    }
}

