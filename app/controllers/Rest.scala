package controllers

import play.api.libs.json._
import play.api.mvc.Action

/**
  * Created by alan on 27/02/16.
  */
object Rest extends NumBitController {

  def fetchTeams = Action {
    Ok(Json.toJson(DataFetcher.fetchAllTeams))
  }

  def futureTournaments(playerId: String, filter: String) = Action {
    Ok(Json.toJson(DataFetcher.fetchFilteredTournaments(playerId: String, filter: String)))
  }

  def tournamentDetails(tid: String) = Action {
    Ok(Json.toJson(DataFetcher.fetchTournamentDetails(tid)))
  }

  def matchInfo(uid: String) = Action {
    Ok(Json.toJson(DataFetcher.fetchMatchInfoForUser(uid)))
  }


}
