//
//  ShareBear.swift
//  BitLit
//
//  Created by Alex Popov on 2015-09-17.
//  Copyright (c) 2015 BitLit. All rights reserved.
//

import Foundation
import UIKit

import BrightFutures
import Result

struct ShareBear {

  let controller: UIViewController
  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

  init(viewController: UIViewController) {
    self.controller = viewController
  }

  func shareText(text: String, andOther other: AnyObject?...) {
    self.presentShareSheetWithText(text, andOthers: other.flatMap({$0})) { (activityType, completed) -> () in
      print("share complete: \(completed) for activity type: \(activityType)")
    }
  }

  ///
  ///
  /// Private Interface!
  ///
  ///
  private func getMediumURL(string: String) -> NSURL? {
    let stringRange = Range<String.Index>(start: string.startIndex, end: string.endIndex)
    let urlString = string.stringByReplacingOccurrencesOfString("/cache/medium", withString: "", options: .LiteralSearch, range: stringRange)
    return NSURL(string: urlString)
  }

  private func startActivityIndicator() {
    // activity indicator
    controller.view.addSubview(activityIndicator)
    Manuscript.layout(activityIndicator) { indicator in
      indicator.centerIn(self.controller.view)
    }
    activityIndicator.startAnimating()
  }

  private func presentShareSheetForImage(image: UIImage?, shareText: String, completionHandler: (activityType: String?, completed: Bool) -> ()) {
    if let shareImage = image {
      let shareSheet = getShareSheetWithActivityItems([shareText, shareImage], applicationActivities: nil)
      shareSheet.completionWithItemsHandler = { (activityType, completed, _, _) in
        completionHandler(activityType: activityType, completed: completed)
      }

      self.controller.presentViewController(shareSheet, animated: true, completion: nil)
    }
  }

  private func presentShareSheetWithText(shareText: String, andOthers others: [AnyObject] = [], completionHandler: (activityType: String?, completed: Bool) -> ()) {
    let shareSheet = getShareSheetWithActivityItems([shareText] + others, applicationActivities: nil)
    shareSheet.completionWithItemsHandler = { (activityType, completed, _, _) in
      completionHandler(activityType: activityType, completed: completed)
    }

    self.controller.presentViewController(shareSheet, animated: true, completion: nil)
  }

  private func getShareSheetWithActivityItems(items: [AnyObject], applicationActivities: [AnyObject]?) -> UIActivityViewController {
    let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
    shareSheet.excludedActivityTypes = [
      UIActivityTypePostToWeibo,
      UIActivityTypeAssignToContact,
      UIActivityTypeAddToReadingList,
      UIActivityTypePostToFlickr,
      UIActivityTypePostToVimeo,
      UIActivityTypePostToTencentWeibo,
    ]
    return shareSheet
  }
}