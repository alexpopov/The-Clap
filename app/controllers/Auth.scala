package controllers

import anorm.SqlParser._
import anorm._
import models.Model.UserData
import play.api.data.Forms._
import play.api.data._
import play.api.mvc.{Action, Security}

/**
  * Created by alan on 27/02/16.
  */
object Auth extends NumBitController {

  val loginForm = Form(
    tuple(
      "email" -> text,
      "password" -> text
    ) verifying("Invalid email or password", result => result match {
      case (email, password) => check(email, password).isDefined
    })
  )

  def check(username: String, password: String): Option[UserData] = {
    val userParser = int("u_id") ~ str("fstname") ~ str("lstname") ~ str("email") ~ str("pw") map { case a ~ b ~ c ~ d ~ e => UserData(a, b, c, d, e) }
    val allUsr = SQL("select * from users").as(userParser.*)
    val filtered = allUsr.filter(udata => udata.email.equals(username))
    filtered match {
      case List() => None //empty fail
      case List(x) => if (x.pw == password) Some(x) else None
      case _ => None // unknown error
    }

  }

  def login = Action { implicit request =>
    Ok(views.html.login(true))
  }

  def authenticate = Action { implicit request =>
    loginForm.bindFromRequest.fold(
      formWithErrors => BadRequest(views.html.login(false)),
      user => Ok(views.html.index(check(user._1, user._2).get))
    )
  }

  def logout = Action {
    Redirect(routes.Auth.login).withNewSession.flashing(
      "success" -> "You are now logged out."
    )
  }
}
