//
//  Board.swift
//  TicTacToeGame
//
//  Created by Vlad on 27.3.24..
//

import Foundation

// Класс, представляющий доску для игры в крестики-нолики
class Board {
    var cells = Array(repeating: Array(repeating: CellState.empty, count: 3), count: 3) // Массив ячеек доски
    
    // Метод для проверки, заполнена ли доска
    func isFull() -> Bool {
        for row in 0..<3 {
            for col in 0..<3 {
                if cells[row][col] == .empty {
                    return false // Если есть хотя бы одна пустая ячейка, доска не заполнена
                }
            }
        }
        return true // Если все ячейки заполнены, доска заполнена
    }
    // Метод для проверки, наступила ли ничья
    func isDraw() -> Bool {
        // Проверяем, заполнена ли доска и нет ли победителя
        return isFull() && !isWinning(player: .cross) && !isWinning(player: .circle)
    }
    // Метод для проверки, выиграл ли игрок
    func isWinning(player: CellState) -> Bool {
        // Проверяем горизонтали и вертикали
        for i in 0..<3 {
            if cells[i][0] == player && cells[i][1] == player && cells[i][2] == player {
                return true // Если три ячейки подряд заняты игроком, игрок выиграл
            }
            if cells[0][i] == player && cells[1][i] == player && cells[2][i] == player {
                            return true // Если три ячейки в одном столбце заняты игроком, игрок выиграл
                        }
                    }
                    
                    // Проверяем диагонали
                    if cells[0][0] == player && cells[1][1] == player && cells[2][2] == player {
                        return true // Если три ячейки на главной диагонали заняты игроком, игрок выиграл
                    }
                    if cells[0][2] == player && cells[1][1] == player && cells[2][0] == player {
                        return true // Если три ячейки на побочной диагонали заняты игроком, игрок выиграл
                    }
                    
                    return false // Иначе игрок не выиграл
                }
                
                // Метод для выполнения хода на доске
                func makeMove(_ move: Move, player: CellState) {
                    if move.row >= 0 && move.row < 3 && move.col >= 0 && move.col < 3 {
                        cells[move.row][move.col] = player // Устанавливаем состояние ячейки для указанного хода
                    } else {
                        // Выводим сообщение об ошибке, если ход за пределами доски
                        print("Недопустимый ход: (\(move.row), \(move.col))")
                    }
                }

                // Метод для получения списка доступных ходов на доске
                func availableMoves() -> [Move] {
                    var moves = [Move]()
                    for row in 0..<3 {
                        for col in 0..<3 {
                            if cells[row][col] == .empty {
                                moves.append(Move(row: row, col: col)) // Добавляем пустую ячейку в список доступных ходов
                            }
                        }
                    }
                    return moves // Возвращаем список доступных ходов
                }
                
                // Метод для создания копии доски
                func copy() -> Board {
                    let newBoard = Board()
                    for i in 0..<3 {
                        for j in 0..<3 {
                            newBoard.cells[i][j] = self.cells[i][j]
                        }
                    }
                    return newBoard
                }
            }
