//
//  CornerRadiusShape.swift
//  WS-WordsFactory
//
//  Created by Daniel Krivelev on 16.04.2022.
//

import SwiftUI

struct CornerRadiusShape: Shape {
  var corners: UIRectCorner
  var radius: CGFloat
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

