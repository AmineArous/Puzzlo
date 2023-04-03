//
//  GameOverView.swift
//  BlocksGame
//
//  Created by Amine Arous on 31/03/2023.
//

import SwiftUI

struct GameOverView: View {

  static let animationDuration: Double = 0.75
  var toColor: Color = .white.opacity(0.8)
  var fromColor: Color = .white.opacity(0.8)
  @State private var outerTrimEnd: CGFloat = 0
  @State private var strokeColor = Color.black
  @State private var scale = 1.0
  @State private var scaleButton = 0.0
  @State private var stopAnimate = false
  @State private var opacity = 0.2

  private let gameOverState: GameViewModel.GameOverState
  private let score: Int

  private let actionPlay: (() -> Void)?
  private let actionMenu: (() -> Void)?
  @State var animateParticule: Bool = false

  init(gameOverState: GameViewModel.GameOverState, score: Int, actionPlay: (() -> Void)?, actionMenu: (() -> Void)?) {
    self.gameOverState = gameOverState
    self.score = score
    self.actionPlay = actionPlay
    self.actionMenu = actionMenu
  }

  var body: some View {
    ZStack {
      HStack {
        Spacer()
        VStack {
          Spacer()
          Text("game.GameOver.title".localized())
            .font(.custom("FarelComic", fixedSize: 35))
            .frame(height: 100)
            .foregroundColor(.white)
            .shadow(color: .black, radius: 10)
            .scaleEffect(scale)
            .padding(20)

          Text("game.GameOver.score".localized())
            .font(.custom("FarelComic", fixedSize: 20))
            .frame(height: 100)
            .foregroundColor(.orange)
            .shadow(color: .black, radius: 10)
            .scaleEffect(scale)

          Text("\(score)")
            .font(.custom("FarelComic", fixedSize: 40))
            .frame(height: 100)
            .foregroundColor(.orange)
            .shadow(color: .black, radius: 10)
            .scaleEffect(scale)

          Button {
            actionPlay?()
          } label: {
            Text("menu.button.play".localized())
              .foregroundColor(.white)
              .font(.custom("FarelComic", fixedSize: 45))
              .frame(width: 250)
              .padding(.top, 10)
            //            .background(Color(hex: "F8BBD0"))
            //            .clipShape(Capsule())
            //            .padding(.bottom, 30)
          }
          .scaleEffect(scaleButton)
          .buttonStyle(NeumorphicButtonStyle())

          Button {
            actionMenu?()
          } label: {
            Text("game.GameOver.button.menu".localized())
              .foregroundColor(.white)
              .font(.custom("FarelComic", fixedSize: 30))
              .frame(width: 150)
              .padding(.top, 10)
            //            .background(Color(hex: "F8BBD0"))
            //            .clipShape(Capsule())
            // .padding(.bottom, 30)
          }
          .scaleEffect(scaleButton)
          .buttonStyle(CapsuleButtonStyle())
          Spacer()
        }
        Spacer()
      }
      EmitterView()
        .opacity(animateParticule ? 1 : 0)
        .ignoresSafeArea()
    }
    .background(content: {
      Color.black.opacity(opacity)
    })
    .edgesIgnoringSafeArea(.all)
    .onAppear {
      if gameOverState == .win {
        withAnimation(.spring()) {
          animateParticule = true
        }
      }
      startAnimate()
    }
  }

  func startAnimate() {
    stopAnimate = false
    scale = 0.0
    animate()
  }

  private func animate() {
    guard stopAnimate == false else { return }

    withAnimation(.linear(duration: ComboCounterView.animationDuration)) {
      scale = 2.0
      opacity = 0.6
    }

    withAnimation(.linear(duration: ComboCounterView.animationDuration).delay(ComboCounterView.animationDuration)) {
      scaleButton = 1.0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + ComboCounterView.animationDuration) {
      stopAnimate = true
    }
  }
}

struct GameOverView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      GameOverView(gameOverState: .win, score: 990909, actionPlay: nil, actionMenu: nil)
//        .background {
//          Color.blue
//        }
    }
  }
}

struct EmitterView: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    view.backgroundColor = .clear

    let emitterLayer = CAEmitterLayer()
    emitterLayer.emitterShape = .line
    emitterLayer.emitterCells = createEmiterCells()

    emitterLayer.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
    emitterLayer.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)

    view.layer.addSublayer(emitterLayer)

    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {

  }

  func createEmiterCells() -> [CAEmitterCell] {

    let allShapes = ["circle.fill", "seal.fill", "rhombus.fill", "triangle.fill", "hexagon.fill"]

    var emiterCells: [CAEmitterCell] = []

    allShapes.forEach { shape in
      let cell = CAEmitterCell()

      let image = UIImage(named: shape)?.cgImage
      cell.contents = image
      cell.color = getColor().cgColor
      cell.birthRate = 4.5
      cell.lifetimeRange = 20
      cell.velocity = 120

      cell.scale = 0.25
      cell.emissionLongitude = .pi
      cell.emissionRange = 0.5
      cell.spin = 3.5
      cell.spinRange = 1
      emiterCells.append(cell)
    }


    return emiterCells
  }

  func getColor() -> UIColor {
    let colors: [UIColor] = [.systemPink, .systemOrange, .systemRed, .systemGreen, .systemPurple]
    return colors.randomElement() ?? .systemPink
  }
}
