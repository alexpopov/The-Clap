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

var API: Client {
return Client.sharedClient
}

enum ClapError: ErrorType {
  case URLInvalid, NoResponse, APIError(error: NSError), JSONError
}

enum RESTMethod: String {
  typealias String = StringLiteralType
  case Get = "GET", Post = "POST", Put = "PUT"
}

class Client {

  static var sharedClient = Client()

  private init() {
  }

  private func startRequest(request: APIRequest.Request) -> Future<AnyObject, ClapError> {
    let apiRequest = APIRequest(request)
    guard let url = apiRequest.url else {
      return .URLInvalid |> Future.init
    }
    let promise = Promise<AnyObject, ClapError>()
    let urlRequest = NSMutableURLRequest(URL: url)
    urlRequest.HTTPMethod = apiRequest.request.method.rawValue
    urlRequest.setValue(self.requestUUID, forHTTPHeaderField: "X-Request-Id")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
      self.sessionDidCompleteForRequest(apiRequest, data: data, response: response, error: error)
        |> promise.complete
    }
    task.resume()
    return promise.future
  }

  var requestUUID: String {
    let theUUID = CFUUIDCreate(nil)
    let uuidString = CFUUIDCreateString(nil, theUUID)
    return String(uuidString)
  }

  private func sessionDidCompleteForRequest(request: APIRequest, data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<AnyObject, ClapError> {
    guard let responseData = data else {
      return Result(error: .NoResponse)
    }
    guard error == nil else {
      return Result(error: ClapError.APIError(error: error!))
    }

    do {
      guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? AnyObject else {
        print("JSON was actually: \(NSString(data: responseData, encoding: NSUTF8StringEncoding))")
        return Result(error: .JSONError)
      }
      return Result(value: json)
    } catch let error {
      print(error)
      return Result(error: .JSONError)
    }
  }

  func getTeams() -> Future<[Team], ClapError> {
    let future = startRequest(.Teams)
      .map { $0 as? [JSON] }
      .map { $0?.flatMap { Team(json: $0) } ?? [] }
    return future
  }

  func getTournaments(filter filter: TournamentFilter) -> Future<[Tournament], ClapError> {
    let future = startRequest(.Tournaments(userID: 0, filter: .Open))
      .map { $0 as? [JSON] }
      .map { $0?.flatMap { Tournament(json: $0) } ?? [] }
    return future
  }


}

enum TournamentFilter: Int {
  case Past = -1, Open = 0, Future = 1
}

class APIRequest {
  static var baseURL = "http://10.19.219.190:9000/rest/"

  enum Request {
    case Teams, Tournaments(userID: UserID, filter: TournamentFilter)
    var method: RESTMethod {
      switch self {
      case Teams, Tournaments:
        return .Get
      }
    }

    var endPoint: String {
      switch self {
      case .Teams:
        return "teams"
      case .Tournaments(let userID, let filter):
        return "tournament/\(userID)/\(filter.rawValue)"
      }
    }
  }

  let request: Request

  init(_ request: Request) {
    self.request = request
  }

  var requestString: String {
    let base = APIRequest.baseURL + request.endPoint
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
typealias UserID = Int

struct Tournament: Keyable {

  var tournamentID: TournamentID
  var name: String
  var game: String
  var date: NSDate
  var current: Int
  var max: Int

  var primaryKey: TournamentID {
    return tournamentID
  }
  // [{"id":2,"name":"nwLan1","game":"Hackz","date":1456819200000,"current":2,"max":8}]$

  init?(json: JSON) {
    guard let tournamentID = json["id"] as? TournamentID
      , let name = json["name"] as? String
      , let game = json["game"] as? String
      , let date = json["date"] as? Double
      , let current = json["current"] as? Int
      , let max = json["max"] as? Int else {
        return nil
    }
    self.tournamentID = tournamentID
    self.name = name
    self.game = game
    self.date = NSDate(timeIntervalSince1970: date)
    self.current = current
    self.max = max
  }
}

typealias JSON = Dictionary<NSObject, AnyObject>

struct Team {
  var teamID: TeamID
  var name: String
  var shortName: String

  init?(json: JSON) {
    guard let teamID = json["id"] as? Int
    , let name = json["name"] as? String else {
      return nil
    }
    self.teamID = teamID
    self.name = name
    self.shortName = "CLG"
  }
}