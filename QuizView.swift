//
//  QuizView.swift
//  vk
//
//  Created by Эльвира on 26.12.2024.
//

import SwiftUI
struct QuizView: View {
    let filmName: String
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var playerTurn = 1
    @State private var selectedAnswer: String?
    @State private var showNextButton = false
    @State private var scores: [Int: Int] = [:]
    @State private var showResults = false
    @State private var answerStatus: [String: Color] = [:]
    @State private var showCorrectAnswer = false
    let numberOfPlayers: Int

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            ).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 10) { // Все элементы сверху
                if showResults {
                    ResultsView(playerScores: scores)
                } else if !questions.isEmpty {
                    let currentQuestion = questions[currentQuestionIndex]

                    // Верхняя панель
                          VStack(alignment: .leading, spacing: 10) {
                              HStack {
                                  Text(filmName)
                                      .font(.headline)
                                      .padding(.vertical, 5)
                                      .padding(.horizontal, 10)
                                      .background(Color.black.opacity(0.1))
                                      .cornerRadius(8)

                                  Spacer()

                                  Text("Вопрос \(currentQuestionIndex + 1) из \(questions.count)")
                                      .font(.subheadline)
                                      .padding(.vertical, 5)
                                      .padding(.horizontal, 10)
                                      .background(Color.black.opacity(0.1))
                                      .cornerRadius(8)
                              }

                              Text("Сейчас отвечает игрок \(playerTurn)")
                                  .font(.subheadline)
                                  .padding(.vertical, 5)
                                  .padding(.horizontal, 10)
                                  .background(Color.black.opacity(0.1))
                                  .cornerRadius(8)
                          }

                          // Вопрос
                        Text(currentQuestion.question)
                        .font(.system(size: 18)) // Размер шрифта ~20sp
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity) // Растягиваем на всю ширину
                        .multilineTextAlignment(.center) // Централизуем текст
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .cornerRadius(10)

                    // Ответы
                    VStack(spacing: 10) {
                        ForEach(currentQuestion.answers, id: \.self) { answer in
                            Button(action: {
                                handleAnswerSelection(answer: answer, correctAnswer: currentQuestion.correctAnswer)
                            }) {
                                HStack {
                                    Text(answer)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(answerStatus[answer] ?? Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .cornerRadius(10)
                            }
                        }
                    }

                    // Кнопка "Далее"
                    if showNextButton {
                        Button("Далее") {
                            handleNextStep()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                } else {
                    Text("Загрузка вопросов...")
                        .onAppear {
                            questions = loadQuestions(forFilm: filmName)
                            if questions.count > 5 {
                                questions.shuffle()
                                questions = Array(questions.prefix(5))
                            }
                        }
                }
            }
            .padding()
        }

    }

    func handleAnswerSelection(answer: String, correctAnswer: String) {
            guard selectedAnswer == nil else { return } // Проверяем, был ли уже выбран ответ

            selectedAnswer = answer
            showNextButton = true

            // Подсветка ответа
            if answer == correctAnswer {
                answerStatus[answer] = Color.green
            } else {
                answerStatus[answer] = Color.red
                answerStatus[correctAnswer] = Color.green
            }
        }

    func handleNextStep() {
        let currentQuestion = questions[currentQuestionIndex]
        
        // Загружаем сохранённые индексы вопросов
        var usedQuestions = UserDefaults.standard.array(forKey: "usedQuestions_\(filmName)") as? [Int] ?? []
        usedQuestions.append(currentQuestionIndex)
        UserDefaults.standard.set(usedQuestions, forKey: "usedQuestions_\(filmName)")

        // Отслеживаем, сколько раз играли в этот фильм
        var playCount = UserDefaults.standard.integer(forKey: "playCount_\(filmName)")
        playCount += 1
        UserDefaults.standard.set(playCount, forKey: "playCount_\(filmName)")

        // Если сыграно 6 игр (30 вопросов), сбрасываем сохранённые вопросы
        if playCount >= 6 {
            UserDefaults.standard.removeObject(forKey: "usedQuestions_\(filmName)")
            UserDefaults.standard.set(0, forKey: "playCount_\(filmName)") // Обнуляем счётчик игр
        }

        if selectedAnswer == currentQuestion.correctAnswer {
            scores[playerTurn, default: 0] += 1
        }

        if numberOfPlayers == 1 {
            currentQuestionIndex += 1
            if currentQuestionIndex >= questions.count {
                showResults = true
                return
            }
        } else {
            playerTurn += 1
            if playerTurn > numberOfPlayers {
                playerTurn = 1
                currentQuestionIndex += 1
                if currentQuestionIndex >= questions.count {
                    showResults = true
                    return
                }
            }
        }

        selectedAnswer = nil
        showNextButton = false
        answerStatus = [:]
        let playCountKey = "playCount_\(filmName)"
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: playCountKey) + 1, forKey: playCountKey)
    }
    }
