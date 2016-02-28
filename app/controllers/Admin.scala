package controllers

import play.api.data.Forms._
import play.api.data._
import play.api.mvc.Action
import anorm._

/**
  * Created by alan on 28/02/16.
  */
object Admin extends NumBitController {

  val tournForm = Form(
    tuple(
      "name" -> text,
      "game" -> text,
      "date" -> date,
      "max" -> number) verifying("Fields cannot be empty", result => result match {
      case (name, game, date, max) => !name.isEmpty && !game.isEmpty && date != null && max > 1
    })
  )

  val temaForm = Form(
    tuple("name" -> text, "tag" -> text) verifying("Fields cannot be empty", result => result match {
      case (name, tag) => !name.isEmpty && !tag.isEmpty && tag.length.equals(3)
    })
  )

  def admin() = Action { implicit request =>
    if (!request2session.isEmpty) {
      val userId = request2session.get("user").get
      Ok(views.html.admin(DataFetcher.fetchSingleUser(userId).fname))
    } else {
      Redirect("/")
    }
  }

  def addTournament() = Action {
    Ok(views.html.addTournament())
  }

  def saveTournament() = Action { implicit request =>
    tournForm.bindFromRequest.fold(
      formWithErrors =>
        BadRequest(views.html.admin(DataFetcher.fetchSingleUser(request2session.get("user").get).fname, "!Field's cannot be empty, max must be greater than 1")),
      tournData => {
        SQL(s"insert into tournament(t_id, name, game, date, cur_reg, max_reg, status)" +
          s" values ({t_id}, {name}, {game}, {date}, {cur_reg}, {max_reg}, {status})").on(
          't_id -> (DataFetcher.fetchAllTournaments.sortBy(_.id).last.id + 1),
          'name -> tournData._1,
          'game -> tournData._2,
          'date -> tournData._3,
          'cur_reg -> 0,
          'max_reg -> tournData._4,
          'status -> 0
        ).executeUpdate()
        val userId = request2session.get("user").get
        Ok(views.html.admin(DataFetcher.fetchSingleUser(userId).fname, "Added tournament!"))
      })
  }

  def addTeam() = Action {
    Ok(views.html.addTeam())
  }

  def saveTeam() = Action { implicit request =>
    temaForm.bindFromRequest.fold(
      formWithErrors =>
        BadRequest(views.html.admin(DataFetcher.fetchSingleUser(request2session.get("user").get).fname, "!Field's cannot be empty and tags must be of length 3")),
      teamData => {
        SQL(s"insert into teams(t_id, name, tag) values ({t_id}, {name}, {tag})").on(
          't_id -> (DataFetcher.fetchAllTeams.sortBy(_.id).last.id + 1),
          'name -> teamData._1,
          'tag -> teamData._2).executeUpdate()
        val userId = request2session.get("user").get
        Ok(views.html.admin(DataFetcher.fetchSingleUser(userId).fname, "Added team!"))
      }
    )
  }


}
