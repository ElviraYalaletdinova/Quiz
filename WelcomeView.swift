//
//  ContentView.swift
//  vk
//
//  Created by Эльвира on 22.12.2024.
//

import SwiftUI
import UserNotifications

struct WelcomeView: View {
    @State private var numberOfPlayers = 1
    @State private var showNotificationAlert = false // Флаг для показа алерта

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Приветствие
                Text("Добро пожаловать в \n Quiz по фильмам!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Вы готовы проверить, насколько хорошо знаете ваши любимые фильмы?")
                    .font(.body)
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                // Выбор количества игроков
                Stepper("Количество игроков: \(numberOfPlayers)", value: $numberOfPlayers, in: 1...15)
                    .padding()

                // Кнопка "Начать игру"
                NavigationLink(destination: FilmSelectionView(numberOfPlayers: numberOfPlayers)) {
                    Text("Начать игру")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .fontWeight(.bold)
                }
                .padding()
            }
            .onAppear {
                requestNotificationPermission() // Запрос разрешения при первом запуске
            }
            .alert(isPresented: $showNotificationAlert) {
                Alert(
                    title: Text("Разрешить уведомления?"),
                    message: Text("Приложение \"Quiz фильмы\" запрашивает разрешение на отправку уведомлений. Уведомления могут содержать напоминания, звуки и наклейки значков."),
                    primaryButton: .default(Text("Разрешить"), action: {
                        requestNotificationPermission()
                    }),
                    secondaryButton: .cancel(Text("Не разрешать"))
                )
            }
            .edgesIgnoringSafeArea(.all)
            .padding()
        }
    }

    /// Запрос разрешения на уведомления
    func requestNotificationPermission() {
        if UserDefaults.standard.bool(forKey: "HasShownNotificationRequest") {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showNotificationAlert = true
            UserDefaults.standard.set(true, forKey: "HasShownNotificationRequest")
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка запроса разрешений: \(error.localizedDescription)")
            }
            print("Разрешение на уведомления: \(granted)")
        }
    }
}

#Preview {
    WelcomeView()
}

