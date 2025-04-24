//
//  ResultsView.swift
//  vk
//
//  Created by Эльвира on 26.12.2024.
//
import SwiftUI

struct ResultsView: View {
    let playerScores: [Int: Int]
    @Environment(\.presentationMode) var presentationMode // Для управления навигацией
    @State private var particles: [ConfettiParticle] = []
    @State private var animate = false

    var body: some View {
        ZStack {
            VStack {
                Text("Результаты теста")
                    .font(.system(size: 24)) // Размер шрифта ~20sp
                    .font(.body)
                    .frame(maxWidth: .infinity) // Растягиваем на всю ширину
                    .padding()

                 Text("ПОЗДРАВЛЯЕМ! 🥳")
                     .font(.system(size: 18)) // Размер шрифта ~20sp
                     .font(.body)
                     .padding(.bottom)

                 List(playerScores.sorted(by: { $0.key < $1.key }), id: \.key) { player, score in
                     Text("Игрок \(player): \(score) баллов")
                 }
                 .frame(height: 300)
                 .multilineTextAlignment(.center) // Централизуем текст
                 .background(Color.white)
                 .foregroundColor(.black)
                 .overlay(
                     RoundedRectangle(cornerRadius: 10)
                         .stroke(Color.black, lineWidth: 1)
                 )
                 .cornerRadius(10)
                
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сыграть снова")
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()

            // Анимация конфетти
            ForEach(particles) { particle in
                ConfettiParticleView(particle: particle)
                    .offset(x: particle.startX, y: animate ? particle.endY : particle.startY)
                    .rotationEffect(.degrees(animate ? particle.rotation : 0))
                    .animation(
                        Animation.easeOut(duration: particle.duration)
                            .repeatCount(1, autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            generateConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animate = true
            }
        }
    }

    // Генерация конфетти частиц
    func generateConfetti() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        for _ in 0..<50 { // Количество конфетти
            let particle = ConfettiParticle(
                id: UUID(),
                color: colors.randomElement()!,
                startX: CGFloat.random(in: -UIScreen.main.bounds.width / 2...UIScreen.main.bounds.width / 2),
                startY: CGFloat.random(in: -UIScreen.main.bounds.height / 2...UIScreen.main.bounds.height / 2),
                endY: CGFloat.random(in: UIScreen.main.bounds.height / 2...UIScreen.main.bounds.height),
                rotation: Double.random(in: 0...360),
                duration: Double.random(in: 2.0...4.0)
            )
            particles.append(particle)
        }
    }
}

// Модель частицы конфетти
struct ConfettiParticle: Identifiable {
    let id: UUID
    let color: Color
    let startX: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let rotation: Double
    let duration: Double
}

// Компонент частицы конфетти
struct ConfettiParticleView: View {
    let particle: ConfettiParticle

    var body: some View {
        Rectangle()
            .fill(particle.color)
            .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
            .cornerRadius(3)
    }
}
