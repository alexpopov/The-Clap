package controllers

import anorm._
import anorm.SqlParser._
import play.api.Play.current
import play.api.db._
import play.api.mvc._

object Application extends Controller {
  implicit val db = DB.getConnection("NumBits")

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def dbTest = Action {
    val rowParser = int("t_id") ~ str("name") map { case n ~ p => (n, p) }
    val x = SQL("select * from Teams").as(rowParser.*)
    Ok(views.html.teams(x))
  }

}