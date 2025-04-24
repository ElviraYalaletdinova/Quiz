//
//  loadQuestions.swift
//  vk
//
//  Created by Эльвира on 23.01.2025.
//
import Foundation
import SwiftUI
func loadQuestions(forFilm film: String) -> [QuizQuestion] {
    guard let url = Bundle.main.url(forResource: "quiz_questions", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Не удалось загрузить файл quiz_questions.json")
        return []
    }

    do {
        let decoder = JSONDecoder()
        let filmQuestions = try decoder.decode(FilmQuestions.self, from: data)
        var allQuestions = filmQuestions.questionsByFilm[film] ?? []

        let usedQuestions = UserDefaults.standard.array(forKey: "usedQuestions_\(film)") as? [Int] ?? []
        let playCount = UserDefaults.standard.integer(forKey: "playCount_\(film)")

        // Проверяем, не пора ли сбросить вопросы
        if playCount >= 6 {
            print("Достигнуто 6 игр, сбрасываем вопросы")
            UserDefaults.standard.removeObject(forKey: "usedQuestions_\(film)")
            UserDefaults.standard.set(0, forKey: "playCount_\(film)")
        } else {
            // Убираем использованные вопросы
            allQuestions = allQuestions.enumerated()
                .filter { !usedQuestions.contains($0.offset) }
                .map { $0.element }
        }

        return allQuestions
    } catch {
        print("Ошибка декодирования JSON: \(error)")
        return []
    }
}
