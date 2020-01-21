//
//  ViewUtils.swift
//  PlanejadorPessoal
//
//  Created by Calvin Gonçalves de Aquino on 1/15/20.
//  Copyright © 2020 Calvin Gonçalves de Aquino. All rights reserved.
//

import UIKit

//Convenience
extension UIView {
  
  // MARK: - Layout Anchor Convenience
  //single anchor convenience
  @discardableResult
  func topAnchor(_ anchor:NSLayoutAnchor<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return topAnchor(anchor, constant: 0)
  }
  
  @discardableResult
  func topAnchor(_ anchor:NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) -> NSLayoutConstraint {
    let constraint = self.topAnchor.constraint(equalTo: anchor, constant: constant)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func bottomAnchor(_ anchor:NSLayoutAnchor<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return bottomAnchor(anchor, constant: 0)
  }
  
  @discardableResult
  func bottomAnchor(_ anchor:NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) -> NSLayoutConstraint {
    let constraint = self.bottomAnchor.constraint(equalTo: anchor, constant: constant)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func leftAnchor(_ anchor:NSLayoutAnchor<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return leftAnchor(anchor, constant: 0)
  }
  
  @discardableResult
  func leftAnchor(_ anchor:NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) -> NSLayoutConstraint {
    let constraint = self.leftAnchor.constraint(equalTo: anchor, constant: constant)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func rightAnchor(_ anchor:NSLayoutAnchor<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return rightAnchor(anchor, constant: 0)
  }
  
  @discardableResult
  func rightAnchor(_ anchor:NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) -> NSLayoutConstraint {
    let constraint = self.rightAnchor.constraint(equalTo: anchor, constant: -constant)
    constraint.isActive = true
    return constraint
  }
  
  //multiple anchor convenience
  @discardableResult
  func horizontalAnchors(_ view: UIView) -> (leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint) {
    return horizontalAnchors(view, leftConstant: 0, rightConstant: 0)
  }
  
  @discardableResult
  func horizontalAnchors(_ view: UIView, leftConstant: CGFloat, rightConstant: CGFloat) -> (leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint) {
    let leftConstraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftConstant)
    let rightConstraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightConstant)
    leftConstraint.isActive = true
    rightConstraint.isActive = true
    return (leftConstraint, rightConstraint)
  }
  
  @discardableResult
  func verticalAnchors(_ view: UIView) -> (topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint) {
    return verticalAnchors(view, topConstant: 0, bottomConstant: 0)
  }
  
  @discardableResult
  func verticalAnchors(_ view: UIView, topConstant: CGFloat, bottomConstant: CGFloat) -> (topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint) {
    let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant)
    let bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant)
    topConstraint.isActive = true
    bottomConstraint.isActive = true
    return (topConstraint, bottomConstraint)
  }
  
  @discardableResult
  func superAnchor(_ view: UIView) -> (topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint) {
    let (topConstraint, bottomConstraint) = verticalAnchors(view, topConstant: 0, bottomConstant: 0)
    let (leftConstraint, rightConstraint) = horizontalAnchors(view, leftConstant: 0, rightConstant: 0)
    return (topConstraint, bottomConstraint, leftConstraint, rightConstraint)
  }
  
  @discardableResult
  func superAnchor(_ view: UIView, topConstant: CGFloat, bottomConstant: CGFloat, leftConstant: CGFloat, rightConstant: CGFloat) -> (topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint) {
    let (topConstraint, bottomConstraint) = verticalAnchors(view, topConstant: topConstant, bottomConstant: bottomConstant)
    let (leftConstraint, rightConstraint) = horizontalAnchors(view, leftConstant: leftConstant, rightConstant: rightConstant)
    return (topConstraint, bottomConstraint, leftConstraint, rightConstraint)
  }
  
  //center
  @discardableResult
  func centerXAnchor(_ view: UIView) -> NSLayoutConstraint {
    let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func centerYAnchor(_ view: UIView) -> NSLayoutConstraint {
    let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func centerAnchor(_ view: UIView) -> (centerXConstraint: NSLayoutConstraint, centerYConstraint: NSLayoutConstraint) {
    let constraintX = centerXAnchor(view)
    let constraintY = centerYAnchor(view)
    return (constraintX, constraintY)
  }
  
  //size
  @discardableResult
  func heightAnchor(sameAsView view: UIView) -> NSLayoutConstraint {
    let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func heightAnchor(constant: CGFloat) -> NSLayoutConstraint {
    let constraint =  heightAnchor.constraint(equalToConstant: constant)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func widthAnchor(sameAsView view: UIView) -> NSLayoutConstraint {
    let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func widthAnchor(constant: CGFloat) -> NSLayoutConstraint {
    let constraint =  widthAnchor.constraint(equalToConstant: constant)
    constraint.isActive = true
    return constraint
  }
  
  @discardableResult
  func sizeAnchor(sameAsView view: UIView) -> (widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
    let widthConstraint = widthAnchor(sameAsView: view)
    let heightConstraint = heightAnchor(sameAsView: view)
    return (widthConstraint, heightConstraint)
  }
  
  @discardableResult
  func sizeAnchor(width: CGFloat, height: CGFloat) -> (widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
    let widthConstraint = widthAnchor(constant: width)
    let heightConstraint = heightAnchor(constant: height)
    return (widthConstraint, heightConstraint)
  }
  
  // MARK: - Frame Convenience
  var left: CGFloat {
    set {
      self.frame.origin.x = newValue
    }
    get {
      self.frame.origin.x
    }
  }

  var top: CGFloat {
    set {
      self.frame.origin.y = newValue
    }
    get {
      self.frame.origin.y
    }
  }

  var right: CGFloat {
    set {
      self.frame.size.width = newValue - self.left
    }
    get {
      self.left + self.frame.size.width
    }
  }
  
  var bottom: CGFloat {
    set {
      self.frame.size.height = newValue - self.top
    }
    get {
      self.top + self.frame.size.height
    }
  }
  
  var width: CGFloat {
    set {
      self.frame.size.width = newValue
    }
    get {
      self.frame.size.width
    }
  }
  
  var height: CGFloat {
    set {
      self.frame.size.height = newValue
    }
    get {
      self.frame.size.height
    }
  }
  
  var safeAreaTop: CGFloat {
    self.safeAreaInsets.top
  }
  
  var safeAreaBottom: CGFloat {
    self.safeAreaInsets.bottom
  }
  
  var safeAreaLeft: CGFloat {
    self.safeAreaInsets.left
  }
  
  var safeAreaRight: CGFloat {
    self.safeAreaInsets.right
  }
  
}

extension UIBarButtonItem {
  static var flexibleSpace: UIBarButtonItem {
    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }
}

extension UIViewController {
  func withNavigation() -> UIViewController {
    UINavigationController(rootViewController: self)
  }
}
