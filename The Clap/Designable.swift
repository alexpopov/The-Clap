//
//  Designable.swift
//  BitLit
//
//  Created by Alex Popov on 2015-10-02.
//  Copyright © 2015 BitLit. All rights reserved.
//

import UIKit


/**
Steps to creating a Designable View:
1. Conform UIView subclass to Designable. This is your `CustomClass`.
2. Create a Nib file with a reasonable name. This will be `nibName`
3. In the Nib file, select File's Owner and set it to `CustomClass`
4. **Do not** set the Nib's class to `CustomClass`
5. Call `nibSetup()` from `init(coder: NSCoder)` and any other initializers.
6. Take a breath
7. Go to another Nib, where you want to use `nibName`.
8. Add a View
9. Set it's Class to `CustomClass`
10. Editer > Refresh Views, or just restart Xcode
- SeeAlso: [iPhoneDev.tv](http://iphonedev.tv/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6)
- important: add the @IBDesignable directive so that it shows up in Interface Builder.
*/
protocol Designable: class {
  var selfReference: UIView { get }
  var view: UIView! { get set }
  var nibName: String { get }
  func setupUI()
}

extension Designable where Self: UIView {

  /**
  Will add the Nib-referenced file to self and align it to all the edges.
  */
  func nibSetup() {
    view = loadViewFromNib()
    selfReference.addSubview(view)
    Manuscript.layout(view) { view in
      view.alignAllEdges(to: self.selfReference)
    }
    setupUI()
  }

  private func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
    return view
  }

}

/**
View to subclass if you don't want the hassle. Make sure to override nibName
*/
class DesignableView: UIView, Designable {
  var nibName: String {
    return NSStringFromClass(self.dynamicType).stringByReplacingOccurrencesOfString("BitLit.", withString: "")
  }

  init() {
    super.init(frame: CGRectZero)
    nibSetup()
  }

  override init(frame: CGRect) {
    super.init(frame: CGRectZero)
    nibSetup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    nibSetup()
  }

  var selfReference: UIView {
    return self
  }

  var view: UIView!

  func setupUI() {

  }

}


