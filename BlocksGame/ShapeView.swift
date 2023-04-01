//
//  ShapeView.swift
//  BlocksGame
//
//  Created by Amine Arous on 31/03/2023.
//

import SwiftUI

struct ShapeView: View {

  private let block: GameViewModel.Block
  private let sizeItem: CGFloat
  @State private var trim = 0.0

  init(block: GameViewModel.Block, sizeItem: CGFloat) {
    self.block = block
    self.sizeItem = sizeItem
  }

  var body: some View {
    VStack {
      ZStack {
        //      Rectangle()
        //        .foregroundColor(.white)
        //        .frame(width: sizeItem, height: sizeItem)
        //        .cornerRadius(sizeItem/3)
        //        .scaleEffect(block.scale)

        RoundedRectangle(cornerRadius: sizeItem/3)
          //.trim(from: 0, to: block.value >= 1024 ? trim : 1)
          .stroke(Color.white, lineWidth: 5)
          .frame(width: sizeItem, height: sizeItem)
          .scaleEffect(block.scale)

        Rectangle()
          .foregroundColor(block.color)
        //.opacity(0.2)
          .frame(width: sizeItem - 5, height: sizeItem - 5)
          .overlay {
            Text(String(block.value))
              .foregroundColor(.white)
              .font(.custom("FarelComic", fixedSize: UIDevice.isPad ? 70 : 40))
              .shadow(radius: 2)
              .minimumScaleFactor(0.6)
              .padding(.top, 10)
              .padding(.horizontal, 5)
          }
          .cornerRadius((sizeItem-5)/3)
          .scaleEffect(block.scale)
//        if block.value >= 1024 {
//          VStack {
//            ConfettiView(color: .yellow, size: sizeItem, opacity: 1.0)
//            ConfettiView(color: .yellow, size: sizeItem, opacity: 1.0)
//          }
//        }
      }
    }
    .onAppear {
      if block.value >= 1024 {
        withAnimation(.linear(duration: 0.5)) {
          trim = 1.0
        }
      }
    }
  }
}

struct ShapeView_Previews: PreviewProvider {
  static var previews: some View {

    ShapeView(block: GameViewModel.Block(value: GameViewModel.Shape._512.rawValue,
                                         position: .zero,
                                         color: GameViewModel.Shape._512.color),
              sizeItem: 100)
    VStack {
//      LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
//        ForEach(GameViewModel.Shape.allCases, id: \.self) { shape in
//          ShapeView(block: GameViewModel.Block(value: shape.rawValue,
//                                               position: .zero,
//                                               color: shape.color),
//                    sizeItem: 100)
//        }
//      }

    }
    .padding(5)
    .background {
      Color.black
    }
  }
}


struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addLines([
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 20),
            CGPoint(x: 0, y: 40),
            CGPoint(x: -10, y: 20)
        ])
        path.closeSubpath()
        return path
    }
}

struct ConfettiView: View {
  let color: Color
  let size: CGFloat
  let opacity: Double

    @State private var offsetY: CGFloat = 0

    var body: some View {
        ConfettiShape()
            .fill(color)
            .frame(width: size, height: size)
            .opacity(opacity)
            .offset(x: size/2 , y: offsetY)
            .onAppear {
              withAnimation(Animation.linear(duration: 0.3).repeatCount(2, autoreverses: false)) {
                    offsetY -= size
                }
            }
    }
}
