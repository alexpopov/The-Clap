package controllers

import anorm.SqlParser._
import anorm._
import play.api.mvc._

object Application extends NumBitController {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def dbTest = Action {
    val rowParser = int("t_id") ~ str("name") map { case n ~ p => (n, p) }
    val x = SQL("select * from Teams").as(rowParser.*)
    Ok(views.html.teams(x))
  }

}