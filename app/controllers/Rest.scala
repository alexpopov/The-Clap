package controllers

import models.Model.{Match, Player, Team, Tournament}
import play.api.libs.json._
import play.api.mvc.Action

/**
  * Created by alan on 27/02/16.
  */
object Rest extends NumBitController {


  def fetchTeams = Action {
    Ok(Json.toJson(DataFetcher.teamFetcher))
  }

  /**
    * Get tournaments based on user id
    *
    * @param playerId string representation of user id
    * @param filter   state -1:Past, 0:Open, 1:Future
    * @return List of tournament in JSON
    */
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
