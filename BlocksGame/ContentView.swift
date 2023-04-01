//
//  ContentView.swift
//  BlocksGame
//
//  Created by Amine Arous on 29/03/2023.
//

import SwiftUI

struct ContentView: View {
  @State var displayContent: GameViewModel.DisplayMode = .menu
  @ObservedObject var viewModel: ContentViewModel

  @State var animateBackground: Bool = false

  @State var animateBackgroundMoreGames: Bool = false

  @State var positionYFirstBackground: CGFloat = -UIScreen.main.bounds.size.height
  @State var positionYSecondBackground: CGFloat = UIScreen.main.bounds.size.height / 2

  init(viewModel: ContentViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      ZStack {


        //GameBackgroundView()
        //Color(hex: "F2F2F2")
        //Color(hex: "F8BBD0")
        //Color(hex: "80CBC4")
        //  .edgesIgnoringSafeArea(.all)

        GeometryReader { proxy in
          VStack(spacing: 0) {
            StripedRectanglesView(colors: [Color(hex: "FFCDD2"), Color(hex: "F5DEB3")])
              //.fill(Color(hex: "607D8B"))
              .frame(height: proxy.size.height)
              .offset(y: animateBackgroundMoreGames ? -proxy.size.height : getFirstOffset(from: proxy.size).y)
              .shadow(radius: 10)
              //.opacity(animateBackground ? 1.0 : displayContent == .menu ? 0.0 : 1.0)
            StripedRectanglesView(colors: [Color(hex: "F5DEB3"), Color(hex: "FFCDD2")])
              //.fill(Color(hex: "FFCDD2"))
              .frame(height: proxy.size.height)
              .offset(y: animateBackgroundMoreGames ? -proxy.size.height : getSecondOffset(from: proxy.size).y)
              .shadow(radius: 10)
              //.opacity(animateBackground ? 1.0 : displayContent == .menu ? 0.0 : 1.0)
          }
          .onLoad {
            withAnimation(.linear(duration: 0.3).delay(0.2)) {
              animateBackground = true
            }
          }
        }
        .edgesIgnoringSafeArea(.all)

        switch displayContent {
        case .menu:
          MenuView(displayContent: $displayContent, animateBackgroundMoreGames: $animateBackgroundMoreGames)
        case .game:
          GameView(viewModel: GameViewModel(displayContent: $displayContent))
        }
        if GameModel.removeAdsPurchase == false {
          viewModel.getAdbannerView()
            .zIndex(2)
        }
      }

    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onChange(of: displayContent) { newValue in
      if newValue == .menu {
        //viewModel.showInterstitialPub()
        positionYFirstBackground = -UIScreen.main.bounds.size.height / 10
        positionYSecondBackground = -UIScreen.main.bounds.size.height / 10
        withAnimation(.linear(duration: 0.3).delay(0.2)) {
          animateBackground = true
        }
      } else {
        withAnimation(.linear(duration: 0.5).delay(0.2)) {
          animateBackground = false
        }
      }
    }

  }

  func getFirstOffset(from size: CGSize) -> CGPoint {
    var point: CGPoint = CGPoint(x: 0, y: 0)

//    if animateBackgroundMoreGames {
//      point.y = -size.height/2
//      return point
//    }

    if animateBackground {
      point.y = -size.height/1.1
    } else {
      if displayContent == .menu {
        point.y = positionYFirstBackground
      } else {
        point.y = 0 //10
      }
    }
    return point
  }

  func getSecondOffset(from size: CGSize) -> CGPoint {
    var point: CGPoint = CGPoint(x: 0, y: 0)

    if animateBackground {
      point.y = -size.height/1.1
    } else {
      if displayContent == .menu {
        point.y = positionYSecondBackground
      } else {
        point.y = 0 //10
      }
    }
    return point
  }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        ContentView(viewModel: ContentViewModel())
      }
//      VStack {
//        WaveView()
//      }
    }
}

struct WaveView: View {
    @State private var xOffset: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            Wave(xOffset: xOffset)
                .fill(Color.white)
                .opacity(0.6)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
        }
        .onAppear {
            self.xOffset = -100
        }
    }
}

struct Wave: Shape {
    var xOffset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let midHeight = height / 2

        path.move(to: CGPoint(x: 0, y: midHeight))
        path.addQuadCurve(to: CGPoint(x: width / 4, y: midHeight - 50), control: CGPoint(x: width / 8, y: midHeight))
        path.addQuadCurve(to: CGPoint(x: width / 2, y: midHeight), control: CGPoint(x: width / 4 + width / 8, y: midHeight + 50))
        path.addQuadCurve(to: CGPoint(x: 3 * width / 4, y: midHeight + 50), control: CGPoint(x: 3 * width / 4 - width / 8, y: midHeight))
        path.addQuadCurve(to: CGPoint(x: width, y: midHeight), control: CGPoint(x: width - width / 8, y: midHeight - 50))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path.offsetBy(dx: xOffset, dy: 0)
    }
}

struct StripedRectanglesView: View {
    let colors: [Color]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<3) { i in
                    Rectangle()
                        .fill(colors[i % colors.count])
                        .frame(width: geometry.size.width / 2)
                        .offset(x: CGFloat(i) * (geometry.size.width / 2))
                }
            }
        }
    }
}
