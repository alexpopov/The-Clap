package controllers

import java.util.Date

import anorm.SqlParser._
import anorm._
import play.api.libs.json.{Json, Writes}
import play.api.mvc.Action

/**
  * Created by alan on 27/02/16.
  */
object Rest extends NumBitController {

  case class Team(id: Int, name: String)

  case class Tournament(id: Int, name: String, game: String, date: Date)

  implicit val teamWrites: Writes[Team] = new Writes[Team] {
    def writes(team: Team) = Json.obj(
      "id" -> team.id,
      "name" -> team.name
    )
  }

  implicit val tournamentWrites: Writes[Tournament] = new Writes[Tournament] {
    def writes(tour: Tournament) = Json.obj(
      "id" -> tour.id,
      "name" -> tour.name,
      "game" -> tour.game,
      "date" -> tour.date
    )
  }

  def fetchTeams = Action {
    val rowParser = int("t_id") ~ str("name") map { case n ~ p => Team(n, p) }
    val select = SQL("select * from Teams").as(rowParser.*)
    Ok(Json.toJson(select))
  }

  def fetchAllTournaments: List[Tournament] = {
    val rowParser = int("t_id") ~ str("name") ~ str("game") ~ date("date") map { case a ~ b ~ c ~ d => Tournament(a, b, c, d) }
    SQL("select * from Tournament").as(rowParser.*)
  }

  /**
    * Get tournaments based on user id
    *
    * @param sid    string representation of user id
    * @param filter state -1:Past, 0:Open, 1:Future
    * @return List of tournament in JSON
    */
  def futureTournaments(sid: String, filter: String) = Action {
    if (sid.nonEmpty) {
      val id = sid.toInt

      if (id > -1) {
        // all teams that this player is on
        val preParser = int("t_id")
        val preSelect = SQL(s"select t.t_id from team_players t where p_id = $id").as(preParser.*)
        val tourParser = int("tour_id") ~ int("team_id") map { case a ~ b => a }
        // all tournaments this team appears in
        val appearsIn = preSelect.flatMap { team_id =>
          SQL(s"select * from tournament_team where team_id = $team_id").as(tourParser.*)
        }

        // from all tournaments, drop the ones with ids that this team appears in
        val toReturn = filter match {
          case "-1" =>
            fetchAllTournaments.filter(tour => appearsIn.contains(tour.id)).filter(
              tour => tour.date.getTime < System.currentTimeMillis())
          case "0" => fetchAllTournaments.filter(tour => !appearsIn.contains(tour.id)).filter(
            tour => tour.date.getTime >= System.currentTimeMillis())
          case "1" => fetchAllTournaments.filter(tour => appearsIn.contains(tour.id)).filter(
            tour => tour.date.getTime >= System.currentTimeMillis())
        }

        Ok(Json.toJson(toReturn))
      } else {
        Ok(Json.toJson(fetchAllTournaments))
      }
    } else {
      Ok(Json.toJson(fetchAllTournaments))
    }
  }
}
