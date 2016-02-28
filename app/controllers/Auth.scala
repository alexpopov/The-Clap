package controllers

import java.security.MessageDigest

import models.Model.UserData
import play.api.data.Forms._
import play.api.data._
import play.api.mvc.{Session, Action}

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
    val allUsr = DataFetcher.fetchAllUsers
    val filtered = allUsr.filter(udata => udata.email.equals(username))
    filtered match {
      case List() => None //empty fail
      case List(x) => if (x.pw == md5(password)) Some(x) else None
      case _ => None // unknown error
    }
  }

  def login = Action { implicit request =>
    Ok(views.html.login(true))
  }

  def md5(s: String) = {
    MessageDigest.getInstance("MD5").digest(s.getBytes).map("%02x".format(_)).mkString
  }

  def authenticate = Action { implicit request =>
    loginForm.bindFromRequest.fold(
      formWithErrors => BadRequest(views.html.login(false)),
      user => {
        val usrData = check(user._1, user._2).get
        val authSession = Session(Map {
          "user" -> usrData.id.toString
        })
        if (usrData.admin) {
          Redirect(routes.Admin.admin()).withSession(authSession)
        } else {
          Redirect(routes.Application.index()).withSession(authSession)
        }
      }
    )
  }

  def logout = Action {
    Redirect(routes.Auth.login).withNewSession.flashing(
      "success" -> "You are now logged out."
    )
  }
}
