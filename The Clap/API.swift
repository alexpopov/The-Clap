//
//  API.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import Foundation
import BrightFutures
import Prelude
import Result

enum ClapError: ErrorType {
  case URLInvalid, NoResponse, APIError(error: NSError), JSONError
}

enum RESTMethod: String {
  typealias String = StringLiteralType
  case Get = "GET", Post = "POST", Put = "PUT"
}

class Client {

  static var sharedClient = Client()

  let endPoint = ""


  private init() {
  }

  func getTournaments() -> Future<Tournament, ClapError> {
    let promise = Promise<Tournament, ClapError>()
    let apiRequest = APIRequest(.Tournaments)
    guard let url = apiRequest.url else {
      return .URLInvalid |> Future.init
    }
    let urlRequest = NSMutableURLRequest(URL: url)
    urlRequest.HTTPMethod = apiRequest.request.method.rawValue
    urlRequest.setValue(self.requestUUID, forHTTPHeaderField: "X-Request-Id")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    urlRequest.setValue(asset.sessionKey, forHTTPHeaderField: "Session-Key")
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
      let result = self.sessionDidCompleteForRequest(apiRequest, data: data, response: response, error: error)
      print(result)
    }
    task.resume()

    return promise.future
  }

  var requestUUID: String {
    let theUUID = CFUUIDCreate(nil)
    let uuidString = CFUUIDCreateString(nil, theUUID)
    return String(uuidString)
  }

  func sessionDidCompleteForRequest(request: APIRequest, data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Dictionary<NSObject, AnyObject>, ClapError> {

    guard let responseData = data else {
      return Result(error: .NoResponse)
    }
    guard error == nil else {
      return Result(error: ClapError.APIError(error: error!))
    }

    do {
      guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? Dictionary<NSObject, AnyObject> else {
        return Result(error: .JSONError)
      }
      return Result(value: json)
    } catch {
      return Result(error: .JSONError)
    }

  }


}

class APIRequest {
  static var baseURL = ""

  enum Request {
    case Tournaments
    var method: RESTMethod {
      return .Get
    }
  }

  let request: Request

  init(_ request: Request) {
    self.request = request
  }

  var requestString: String {
    let base = APIRequest.baseURL

    return base
  }

  var url: NSURL? {
    return NSURL(string: requestString)
  }
}

protocol Keyable {
  var primaryKey: Int { get }
}

typealias TournamentID = Int
typealias TeamID = Int

struct Tournament: Keyable {

  var tournamentID: TournamentID
  var name: String
  var team1ID: TeamID

  var primaryKey: TournamentID {
    return tournamentID
  }

}