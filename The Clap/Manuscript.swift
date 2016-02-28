//
//  Manuscript.swift
//  Manuscript
//
//  Created by Florian Krüger on 17/11/14.
//  Copyright (c) 2014 projectserver.org. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

/// A bunch of utils that Manuscript uses internally (OK, it's only one util for now but there may
/// be more later).
///
/// This has been extracted as a protocol to provide testability.

public protocol ManuscriptUtils {

  /// Check whether we're running on a system that has a so-called "Retina" display.
  ///
  /// - returns: `true` if the `scale` of the main screen is greater than 1.0, `false` otherwise
  
  func isRetina() -> Bool
}

/// This is `Manuscript`. You should only need to interact with this part of the framework directly.
///
/// Usage:
///
/// ```
/// Manuscript.layout(<your view>) { c in
///   // create your constraints here
/// }
/// ```
///
/// See `Manuscript.layout` for more details

public struct Manuscript {

  /// This is just public for testing purposes and will be private in future releases when Xcode 7
  /// is out of beta.
  ///
  /// - parameter utils: an instance of `ManuscriptUtils` which is provided by default if you use
  ///               `layout` method
  /// - parameter view: the `UIView` that should be layouted
  /// - parameter block: a block that is provided with a `LayoutProxy` that is already setup with the
  ///              given `view`. You can create AutoLayout constraints through this proxy.
  ///
  /// - returns: the `LayoutProxy` instance that is also handed to the `block`

  public static func makeLayout(@autoclosure utils utils: () -> ManuscriptUtils)(_ view: UIView, block: (LayoutProxy) -> ()) -> Manuscript.LayoutProxy {
    let layoutProxy = LayoutProxy(view: view, utils: utils())
    block(layoutProxy)
    return layoutProxy
  }

  /// Use this to define your AutoLayout constraints in your code. Calls `makeLayout` with the
  /// default `ManuscriptUtils` implementation.
  ///
  /// see `makeLayout` for additional details on the parameters

  public static var layout = Manuscript.makeLayout(utils: Manuscript.Utils())

  static func findCommonSuperview(a: UIView, b: UIView?) -> UIView? {

    if let b = b {

      // Quick-check the most likely possibilities
      let (aSuper, bSuper) = (a.superview, b.superview)
      if a == bSuper { return a }
      if b == aSuper { return b }
      if aSuper == bSuper { return aSuper }

      // None of those; run the general algorithm
      let ancestorsOfA = NSSet(array: Array(ancestors(a)))
      for ancestor in ancestors(b) {
        if ancestorsOfA.containsObject(ancestor) {
          return ancestor
        }
      }
      return nil // No ancestors in common
    }

    return a // b is nil
  }

  static func ancestors(v: UIView) -> AnySequence<UIView> {
    return AnySequence { () -> AnyGenerator<UIView> in
      var view: UIView? = v
      return anyGenerator {
        let current = view
        view = view?.superview
        return current
      }
    }
  }

  struct Utils: ManuscriptUtils {
    func isRetina() -> Bool {
      return UIScreen.mainScreen().scale > 1.0
    }
  }

}
