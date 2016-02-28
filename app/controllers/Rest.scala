package controllers

import java.util.Date

import anorm.SqlParser._
import anorm._
import play.api.libs.json._
import play.api.mvc.Action

/**
  * Created by alan on 27/02/16.
  */
object Rest extends NumBitController {

  case class Team(id: Int, name: String)

  case class Tournament(id: Int, name: String, game: String, date: Date, cur: Int, max: Int)

  case class Player(id: Int, user_id: Int, nick: String)

  val teamParser = int("t_id") ~ str("name") map { case n ~ p => Team(n, p) }

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
      "date" -> tour.date,
      "current" -> tour.cur,
      "max" -> tour.max
    )
  }

  implicit val playerWrites: Writes[Player] = new Writes[Player] {
    def writes(player: Player) = Json.obj(
      "id" -> player.id,
      "u_id" -> player.user_id,
      "nick" -> player.nick
    )
  }

  implicit val detailWrites: Writes[(Team, List[Player])] = new Writes[(Team, List[Player])] {
    def writes(details: (Team, List[Player])) = Json.obj(
      "team" -> Json.toJson(details._1),
      "players" -> Json.toJson(JsArray(details._2.map(Json.toJson(_))))
    )
  }

  def fetchTeams = Action {
    val select = SQL("select * from Teams").as(teamParser.*)
    Ok(Json.toJson(select))
  }

  def fetchAllTournaments: List[Tournament] = {
    val rowParser = int("t_id") ~ str("name") ~ str("game") ~ date("date") ~ int("cur_reg") ~ int("max_reg") map {
      case a ~ b ~ c ~ d ~ e ~ f => Tournament(a, b, c, d, e, f)
    }
    SQL("select * from Tournament").as(rowParser.*)
  }

  /**
    * Get tournaments based on user id
    *
    * @param playerId string representation of user id
    * @param filter   state -1:Past, 0:Open, 1:Future
    * @return List of tournament in JSON
    */
  def futureTournaments(playerId: String, filter: String) = Action {
    if (playerId.nonEmpty) {
      val id = playerId.toInt

      if (id > -1) {
        // all teams that this player is on
        val preSelect = SQL(s"select t.t_id from team_players t where p_id = $id").as(int("t_id").*)
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

  def tournamentDetails(tid: String) = Action {
    val select = SQL(s"select Tournament.t_id from Tournament where Tournament.t_id=$tid").as(int("t_id").*)
    val toReturn = select match {
      case List(x) =>
        val tourIds = SQL(s"select t.t_id from Tournament t where t.t_id=$x").as(int("t_id").*)
        // all teams in tournament
        val allTeamIds = tourIds.flatMap { tourId =>
          SQL(s"select * from tournament_team t where t.tour_id=$tourId").as(int("team_id").*)
        }
        val allTeams = allTeamIds.flatMap { teamId =>
          SQL(s"select * from teams t where t.t_id=$teamId").as(teamParser.*)
        }
        // all player ids in tour
        val allPlayers = allTeams.map {
          team => (team, SQL(s"select tp.p_id from team_players tp where tp.t_id = ${team.id}").as(int("p_id").*))
        }
        val playerParser = int("p_id") ~ int("u_id") ~ str("nick") map { case a ~ b ~ c => Player(a, b, c) }
        val allTeamsWithPlayers = allPlayers.map {
          team => (team._1, team._2.flatMap(
            playerId => SQL(s"select * from players where players.p_id=$playerId").as(playerParser.*)))
        }
        allTeamsWithPlayers
      case _ => List()
    }
    Ok(Json.toJson(toReturn))
  }

  def matchInfo(uid: String) = Action {

  }
}
