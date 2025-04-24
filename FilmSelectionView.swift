//
//  FilmSelectionView.swift
//  vk
//
//  Created by Эльвира on 26.12.2024.
//
import SwiftUI
struct FilmSelectionView: View {
    private let films = [
        "Гарри Поттер",
        "Властелин Колец",
        "Звездные войны",
        "Игра престлов",
        "Симпсоны",
        "Во все тяжкие",
        "Как я встретил вашу маму",
        "Офис",
        "Друзья",
        "Секс в большом городе",
        "Клиника"
    ]
    
    let numberOfPlayers: Int // Число игроков передаётся из предыдущего экрана

    var body: some View {
        List(films, id: \.self) { film in
            NavigationLink(destination: QuizView(filmName: film, numberOfPlayers: numberOfPlayers)) {
                HStack {
                    Image(systemName: "film")
                        .foregroundColor(.blue)
                    Text(film)
                        .font(.body)
                        .padding(.leading, 8)
                }

            }
        }
        .navigationTitle("Выберите фильм")
        .font(.title)
    }
}

