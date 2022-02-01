//
//  DraggableView.swift
//  One-to-one-call-demo
//
//  Created by Asif Ayub on 6/21/21.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import UIKit

class DraggableView: UIView {
    
    private let screenSize = UIApplication.shared.windows.first?.bounds ?? UIScreen.main.bounds
    private let isNotchScreen = (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
    
    init(frame: CGRect = .zero, position: CGPoint = .zero, cornerRadius: CGFloat = 0) {
        super.init(frame: frame)
        if frame == .zero {
            self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self.center = localViewOrigin()
        }
        setupUI(cornerRadius: cornerRadius)
        addPanGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame = CGRect(x: 0, y: 0, width: 130, height: 170)
        self.center = localViewOrigin()
        setupUI(cornerRadius: 20)
        addPanGesture()
//        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(cornerRadius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    private func localViewOrigin() -> CGPoint {
        let superViewSize = UIScreen.main.bounds
        let viewSize = self.bounds
        let trailingSpace: CGFloat = 20
        let bottomSpace: CGFloat = isNotchScreen ? 145 : 113
        let x = superViewSize.width - (viewSize.width / 2) - trailingSpace
        let y = superViewSize.height - (viewSize.height / 2) - bottomSpace
        return CGPoint(x: x, y: y)
    }
    
    private func getValidConstraints(for view: UIView) -> (trailing: CGFloat, bottom: CGFloat) {
        let currentPoint = view.frame.origin
        print(currentPoint)
        let viewSize = view.bounds
        let constraint: CGFloat = 20
        let top = isNotchScreen ? (constraint * 3) : constraint
        let constraints: (leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) = (constraint, constraint + self.bounds.width, top, constraint + self.bounds.height)
        let bottom: CGFloat
        let trailing: CGFloat
        if currentPoint.x < constraints.leading {
            trailing = screenSize.width - (constraints.leading + viewSize.width)
        } else if currentPoint.x > screenSize.width - constraints.trailing {
            trailing = constraint
        } else {
            trailing = screenSize.width - (currentPoint.x + viewSize.width)
        }
        
        if currentPoint.y < constraints.top {
            bottom = screenSize.height - (constraints.top + viewSize.height)
        } else if currentPoint.y > (screenSize.height - constraints.bottom) {
            bottom = constraint
        } else {
            bottom = screenSize.height - (currentPoint.y + viewSize.height)
        }
        
        return (trailing, bottom)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let view = self
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
      )

      // 3
      gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
          return
        }

        // 1
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200

        // 2
        let slideFactor = 0.1 * slideMultiplier
        // 3
        var finalPoint = CGPoint(
            x: gestureView.center.x + (velocity.x * slideFactor),
          y: gestureView.center.y + (velocity.y * slideFactor)
        )

        // 4
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)
          let constraints = self.getValidConstraints(for: gestureView)
        let point = CGPoint(x: screenSize.width - constraints.trailing - 65, y: screenSize.height - constraints.bottom - 85)
        
        // 5
        UIView.animate(
            withDuration: 0.1,
          delay: 0,
          options: .curveEaseOut,
          animations: {
            gestureView.center = point
          })
    }
}
