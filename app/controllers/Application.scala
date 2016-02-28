package controllers

import models.Model.{Team, Match, Tournament}
import play.api.mvc._

object Application extends NumBitController {

  def index() = Action { implicit request =>
    if (!request2session.isEmpty) {
      if (request2session.get("user").isDefined) {
        val userId = request2session.get("user").get
        val allUsers = DataFetcher.fetchAllUsers
        val user = allUsers.filter(_.id.toString == userId)

        val upcoming: (Tournament, Match, Team, Team) = DataFetcher.fetchMatchInfoForUser(userId)
        Ok(views.html.index(user.head, upcoming))
      } else {
        Redirect("/login")
      }
    } else {
      Redirect("/login")
    }
  }

  def details() = Action { implicit request =>
    if (!request2session.isEmpty) {
      val userId = request2session.get("user").get
      val upcoming: (Tournament, Match, Team, Team) = DataFetcher.fetchMatchInfoForUser(userId)
      Ok(views.html.details(upcoming))
    } else {
      Redirect("/")
    }
  }

}