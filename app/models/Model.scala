package models

import java.util.Date

/**
  * Created by alan on 27/02/16.
  */
object Model {

  case class UserData(id: Int, fname: String, lname: String, email: String, pw: String, admin: Boolean)

  case class Team(id: Int, name: String, nick: String)

  case class Tournament(id: Int, name: String, game: String, date: Long, cur: Int, max: Int, status: Int)

  case class Player(id: Int, user_id: Int, nick: String)

  case class Match(id: Int, tour_id: Int, t1_id: Int, t2_id: Int, ip: String, time: Long, score1: Int, score2: Int,
                   round: Int)

}
