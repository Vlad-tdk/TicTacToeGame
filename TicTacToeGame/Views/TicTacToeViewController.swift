//
//  ViewController.swift
//  TicTacToeGame
//
//  Created by Vlad on 27.3.24..
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    private var viewModel: TicTacToeViewModel! // ViewModel для обработки логики игры
    private var fields = [[UIView]]() // Массив полей на игровой доске
    private let fieldSize: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 3 - 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameBoard() // Настройка игровой доски
        viewModel = TicTacToeViewModel() // Инициализация ViewModel
        viewModel.currentPlayer = .cross // Установка текущего игрока на крестик
    }
    
    // Метод для настройки игровой доски с полями
    private func setupGameBoard() {
        for i in 0..<3 {
            var rowFields = [UIView]() // Временный массив полей для текущей строки
            
            for j in 0..<3 {
                let fieldView = UIView()
                fieldView.tag = i * 3 + j // Уникальный тег для каждого поля
                fieldView.backgroundColor = .white
                fieldView.layer.borderWidth = 1
                fieldView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(fieldView)
                fieldView.translatesAutoresizingMaskIntoConstraints = false
                fieldView.widthAnchor.constraint(equalToConstant: fieldSize).isActive = true
                fieldView.heightAnchor.constraint(equalToConstant: fieldSize).isActive = true
                fieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(j) * (fieldSize + 10) + 10).isActive = true
                fieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(i) * (fieldSize + 10) + 100).isActive = true
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fieldTapped(_:))) // Жест для поля
                tapGesture.numberOfTapsRequired = 1
                tapGesture.numberOfTouchesRequired = 1
                fieldView.addGestureRecognizer(tapGesture)
                
                rowFields.append(fieldView) // Добавление поля во временный массив
            }
            
            fields.append(rowFields) // Добавление временного массива полей в основной массив
        }
    }
    
    // Обработчик нажатия на поле
    @objc private func fieldTapped(_ sender: UITapGestureRecognizer) {
        guard let fieldView = sender.view else { return }
        let row = fieldView.tag / 3
        let col = fieldView.tag % 3

        print("Tapped at (\(row), \(col))") // Вывод в консоль координат нажатой ячейки

        guard let viewModel = viewModel else { return } // Проверка на наличие ViewModel

        // Проверяем, является ли ячейка пустой
        guard viewModel.isCellEmpty(row: row, col: col) else {
            print("Cell is already occupied: (\(row), \(col))")
            return
        }

        // Пользователь делает свой ход
        if let winner = viewModel.makeMove(row: row, col: col) {
            showWinnerAlert(winner: winner) // Отображение окна с результатом игры
            return // Возвращаемся, чтобы не делать ход ИИ после завершения игры
        }

        // Установка текста на поле для пользователя
        let currentPlayer = viewModel.currentPlayer.rawValue
        let label = UILabel(frame: fieldView.bounds)
        label.text = currentPlayer
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        fieldView.addSubview(label)

        viewModel.currentPlayer = .circle

        // Проверяем, завершена ли игра после хода игрока
        if let aiMove = viewModel.makeAIMove() {
            let aiRow = aiMove.0
            let aiCol = aiMove.1
            let win = aiMove.2
            if win {
                showWinnerAlert(winner:( aiMove.0, aiMove.1))
            }else if viewModel.gameBoard.isDraw() {
                showDrawAlert() // Отображение окна с сообщением о ничье
                return // Возвращаемся, чтобы не делать ход ИИ после завершения игры
            }
            // Установка текста на поле для ИИ
            let aiLabel = UILabel(frame: fields[aiRow][aiCol].bounds)
            aiLabel.text = viewModel.currentPlayer.rawValue
            aiLabel.font = UIFont.systemFont(ofSize: 30)
            aiLabel.textAlignment = .center
            fields[aiRow][aiCol].addSubview(aiLabel)
            viewModel.currentPlayer = .cross
        }
    }
    // Отображение окна с результатом игры
    private func showWinnerAlert(winner: (Int, Int)) {
        let alertController = UIAlertController(title: "Игра окончена", message: "\(viewModel.currentPlayer.rawValue) выиграл!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Начать заново", style: .default) { [weak self] _ in
            self?.restartGame() // Перезапуск игры
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
        highlightWinnerField(winner: winner) // Подсветка победного поля
    }
    // Отображение окна с Ничьей
    private func showDrawAlert(){
        let alertController = UIAlertController(title: "Ничья", message: "У Вас Ничья!", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Начать заново", style: .default) { [weak self] _ in
            self?.restartGame() // Перезапуск игры
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    // Перезапуск игры
    private func restartGame() {
        viewModel = TicTacToeViewModel() // Создание новой ViewModel для начала новой игры
        for row in fields {
            for fieldView in row {
                fieldView.subviews.forEach { $0.removeFromSuperview() } // Очистка текста на полях
                fieldView.backgroundColor = .white // Возвращение белого цвета фона на поле
            }
        }
    }
    
    // Подсветка поля, образующего выигрышную комбинацию
    private func highlightWinnerField(winner: (Int, Int)) {
        let fieldView = fields[winner.0][winner.1] // Получение выигрышного поля
        let currentPlayer = viewModel.currentPlayer.rawValue
        let label = UILabel(frame: fieldView.bounds)
        label.text = currentPlayer
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        fieldView.addSubview(label)
        fieldView.backgroundColor = .yellow // Установка желтого цвета фона на поле
    }
}
