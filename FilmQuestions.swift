//
//  Question.swift
//  vk
//
//  Created by Эльвира on 23.01.2025.
//
import Foundation
import SwiftUI
struct FilmQuestions: Decodable {
    let questionsByFilm: [String: [QuizQuestion]]
}
struct QuizQuestion: Codable, Identifiable {
    let id: String
    let question: String
    let answers: [String]
    let correctAnswer: String

}
