package controllers

import anorm.SqlParser._
import anorm._
import play.api.db.DB
import play.api.libs.json.Json
import play.api.mvc.Controller
import play.api.Play.current

/**
  * Created by alan on 27/02/16.
  */
object Rest extends Controller {

  implicit val db = DB.getConnection("NumBits")

  def teams = {
    val rowParser = int("t_id") ~ str("name") map { case n ~ p => (n, p) }
    val x = SQL("select * from Teams").as(rowParser.*)
    Json.toJson(x)
  }
}
