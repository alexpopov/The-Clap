package controllers

import java.security.MessageDigest

import models.Model.{Match, Player, Tournament, Team}
import play.api.Play.current
import play.api.db.DB
import play.api.libs.json.{JsArray, Json, Writes}
import play.api.mvc.Controller

/**
  * Created by alan on 27/02/16.
  */
class NumBitController extends Controller with NumBitDataLayer

trait NumBitDataLayer {
  implicit val db = DB.getConnection("NumBits")

  implicit val teamWrites: Writes[Team] = new Writes[Team] {
    def writes(team: Team) = Json.obj(
      "id" -> team.id,
      "name" -> team.name,
      "nick" -> team.nick
    )
  }

  implicit val tournamentWrites: Writes[Tournament] = new Writes[Tournament] {
    def writes(tour: Tournament) = Json.obj(
      "id" -> tour.id,
      "name" -> tour.name,
      "game" -> tour.game,
      "date" -> tour.date,
      "current" -> tour.cur,
      "max" -> tour.max,
      "status" -> tour.status
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

  implicit val matchWrites: Writes[Match] = new Writes[Match] {
    def writes(mat: Match) = Json.obj(
      "id" -> mat.id,
      "tour_id" -> mat.tour_id,
      "team1_id" -> mat.t1_id,
      "team2_id" -> mat.t2_id,
      "ip" -> mat.ip,
      "time" -> mat.time,
      "score1" -> mat.score1,
      "score2" -> mat.score2,
      "round" -> mat.round
    )
  }

  implicit val comingWries: Writes[(Tournament, Match, Team, Team)] = new Writes[(Tournament, Match, Team, Team)] {
    def writes(coming: (Tournament, Match, Team, Team)) = Json.obj(
      "tournament" -> Json.toJson(coming._1),
      "match" -> Json.toJson(coming._2),
      "myTeam" -> Json.toJson(coming._3),
      "otherTeam" -> Json.toJson(coming._4)
    )
  }

  def md5(s: String) = {
    MessageDigest.getInstance("MD5").digest(s.getBytes).map("%02x".format(_)).mkString
  }
}