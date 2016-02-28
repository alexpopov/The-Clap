package controllers

import models.Model.UserData
import play.api.mvc._

object Application extends NumBitController {

  def index(user: Option[UserData] = None) = Action {
    if (user.isDefined) {
      Ok(views.html.index(user.get))
    } else {
      Redirect("/login")
    }
  }

}