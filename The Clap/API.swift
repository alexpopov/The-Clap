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
      let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
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
    let future = startRequest(.Tournaments(userID, filter))
      .map { $0 as? [JSON] }
      .map { $0?.flatMap { Tournament(json: $0) } ?? [] }
    return future
  }

  func getTournamentDetails(tournamentID: TournamentID) -> Future<TournamentDetails, ClapError> {
    let future = startRequest(.TournamentDetails(tournamentID))
      .map { $0 as? [JSON] ?? [] }
      .map { $0.flatMap { TournamentDetails(json: $0) } }
      .flatMap { (details: TournamentDetails?) -> Future<TournamentDetails, ClapError> in
        guard let details = details else {
          return Future(error: ClapError.JSONError)
        }
        return Future(value: details)
    }
    return future
  }

  func getUpcomingMatch() -> Future<UpcomingMatch, ClapError> {
    let future = startRequest(.UpcomingMatch(userID))
      .map { $0 as? JSON ?? JSON() }
      .map { UpcomingMatch(json: $0) }
      .flatMap { (match: UpcomingMatch?) -> Future<UpcomingMatch, ClapError> in
        guard let match = match else {
          return Future(error: .JSONError)
        }
        return Future(value: match)
    }

    return future
  }
}

let userID = 1

enum TournamentFilter: Int {
  case Past = -1, Open = 0, Future = 1
}

class APIRequest {
  static var baseURL = "http://10.19.219.190:9000/rest/"

  enum Request {
    case Teams, Tournaments(UserID, TournamentFilter), TournamentDetails(TournamentID), UpcomingMatch(UserID)
    var method: RESTMethod {
      switch self {
      case .Teams:
        return .Get
      case .Tournaments(_, _):
        return .Get
      case .TournamentDetails(_):
        return .Get
      case .UpcomingMatch(_):
        return .Get
      }
    }

    var endPoint: String {
      switch self {
      case .Teams:
        return "teams"
      case .Tournaments(let userID, let filter):
        return "tournament/\(userID)/\(filter.rawValue)"
      case .TournamentDetails(let tournamentID):
        return "tournamentDetails/\(tournamentID)"
      case .UpcomingMatch(let userID):
        return "upcomingMatch/\(userID)"
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

  var formattedDate: String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ccc LLL d"
    return formatter.stringFromDate(date)
  }

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

struct TournamentDetails {

  var teamPlayers: [TeamPlayers]

//  [{"team":{"id":1,"name":"Cans"},"players":[{"id":1,"u_id":1,"nick":"Cannibal Dolphin"},{"id":2,"u_id":2,"nick":"Cannibal Poro"}]},{"team":{"id":2,"name":"Normies"},"players":[{"id":3,"u_id":1,"nick":"Apopo"},{"id":4,"u_id":2,"nick":"alee"}]}]
  init?(json: [JSON]) {
    let teamPlayers = json.flatMap { TeamPlayers(json: $0) }
    self.teamPlayers = teamPlayers
  }
}

typealias JSON = Dictionary<NSObject, AnyObject>
typealias PlayerID = Int
typealias MatchID = Int

struct Team {
  var teamID: TeamID
  var name: String
  var shortName: String

  init?(json: JSON) {
    guard let teamID = json["id"] as? Int
      , let name = json["name"] as? String
      , let nick = json["nick"] as? String else {
      return nil
    }
    self.teamID = teamID
    self.name = name
    self.shortName = nick
  }
}

struct Player {
  var playerID: PlayerID
  var userID: UserID
  var nickname: String

  init?(json: JSON) {
    guard let pID = json["id"] as? Int
      , let uID = json["u_id"] as? Int
      , let nick = json["nick"] as? String else {
        return nil
    }
    self.playerID = pID
    self.userID = uID
    self.nickname = nick
  }
}

struct TeamPlayers {
  var team: Team
  var players: [Player]

  init?(json: JSON) {
    guard let _team = json["team"] as? JSON
      , let _players = json["players"] as? [JSON]
      , let team = Team(json: _team) else {
        return nil
    }
    let players = _players.flatMap { Player(json: $0) }
    self.team = team
    self.players = players
  }
}

/*{"tournament":
      {"id":1,"name":"nwLan","game":"Hackz","date":1456732800000,"current":2,"max":8,"status":1},
  "match":
      {"id":1,"tour_id":1,"team1_id":1,"team2_id":2,"ip":"192.168.1.1/32","time":1456646400000,"score1":0,"score2":0,"round":1},
    "myTeam":
        {"id":1,"name":"Cans","nick":"CAN"},
    "otherTeam":
        {"id":2,"name":"Normies","nick":"NOR"}}

*/
struct UpcomingMatch {
  var tournament: Tournament
  var match: Match
  var myTeam: Team
  var otherTeam: Team

  init?(json: JSON) {
    guard
        let _tournament = json["tournament"] as? JSON
      , let _match = json["match"] as? JSON
      , let _myTeam = json["myTeam"] as? JSON
      , let _otherTeam = json["otherTeam"] as? JSON
      , let tournament = Tournament(json: _tournament)
      , let match = Match(json: _match)
      , let myTeam = Team(json: _myTeam)
      , let otherTeam = Team(json: _otherTeam)
      else {
        return nil
    }
    self.tournament = tournament
    self.match = match
    self.myTeam = myTeam
    self.otherTeam = otherTeam
  }

}

// {"id":1,"tour_id":1,"team1_id":1,"team2_id":2,"ip":"192.168.1.1/32","time":1456646400000,"score1":0,"score2":0,"round":1},

struct Match {
  var matchID: MatchID
  var tournamentID: TournamentID
  var team1ID: TeamID
  var team2ID: TeamID
  var ipAddress: String
  var date: NSDate
  var score1: Int
  var score2: Int
  var round: Int

  init?(json: JSON) {
    guard
        let matchID = json["id"] as? Int
      , let t_id = json["tour_id"] as? Int
      , let team1_id = json["team1_id"] as? Int
      , let team2_id = json["team2_id"] as? Int
      , let ip = json["ip"] as? String
      , let time = json["time"] as? NSTimeInterval
      , let score1 = json["score1"] as? Int
      , let score2 = json["score2"] as? Int
      , let round = json["round"] as? Int
      else {
        return nil
    }
    self.matchID = matchID
    self.tournamentID = t_id
    self.team1ID = team1_id
    self.team2ID = team2_id
    self.ipAddress = ip
    self.date = NSDate(timeIntervalSince1970: time)
    self.score1 = score1
    self.score2 = score2
    self.round = round
  }
}