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
    }
    
}
