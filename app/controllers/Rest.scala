package controllers

import anorm.SqlParser._
import anorm._
import play.api.libs.json.{Json, Writes}
import play.api.mvc.Action

/**
  * Created by alan on 27/02/16.
  */
object Rest extends NumBitController {

  case class Team(id: Int, name: String)

  implicit val teamWrites: Writes[Team] = new Writes[Team] {
    def writes(team: Team) = Json.obj(
      "id" -> team.id,
      "name" -> team.name
    )
  }

  def fetchTeams = Action {
    val rowParser = int("t_id") ~ str("name") map { case n ~ p => Team(n, p) }
    val x = SQL("select * from Teams").as(rowParser.*)
    Ok(Json.toJson(x))
  }
}
