package controllers

import anorm.SqlParser._
import anorm._
import models.Model.{Match, Tournament, Player, Team}
import models._
import play.api.libs.json.{JsValue, Json}

/**
  * Created by alan on 28/02/16.
  */
object DataFetcher extends NumBitDataLayer {

  val teamParser = int("t_id") ~ str("name") ~ str("tag") map { case a ~ b ~ c => Team(a, b, c) }
  val playerParser = int("p_id") ~ int("u_id") ~ str("nick") map { case a ~ b ~ c => Player(a, b, c) }
  val tournamentParser = int("t_id") ~ str("name") ~ str("game") ~ date("date") ~ int("cur_reg") ~ int("max_reg") ~ int("status") map {
    case a ~ b ~ c ~ d ~ e ~ f ~ g => Tournament(a, b, c, d, e, f, g)
  }
  val matchParser = int("m_id") ~ int("tour_id") ~ int("team1_id") ~ int("team2_id") ~ str("ip") ~ date("time") ~ int("score1") ~ int("score2") ~ int("round") map {
    case a ~ b ~ c ~ d ~ e ~ f ~ g ~ h ~ i => Match(a, b, c, d, e, f, g, h, i)
  }

  def teamFetcher: List[Team] = {
    SQL("select * from Teams").as(teamParser.*)
  }

  def fetchAllTournaments: List[Tournament] = {
    SQL("select * from Tournament").as(tournamentParser.*)
  }

  /**
    * Get tournaments based on user id
    *
    * @param playerId string representation of user id
    * @param filter   state -1:Past, 0:Open, 1:Future
    * @return List of tournament in JSON
    */
  def fetchFilteredTournaments(playerId: String, filter: String): List[Tournament] = {
    if (playerId.nonEmpty) {
      val id = playerId.toInt
      if (id > -1) {
        // all teams that this player is on
        val preSelect = SQL(s"select t.t_id from team_players t where p_id = $id").as(int("t_id").*)
        val tourParser = int("tour_id") ~ int("team_id") map { case a ~ b => a }
        // all tournaments this team appears in
        val appearsIn = preSelect.flatMap { team_id =>
          SQL(s"select * from tournament_team where team_id = $team_id").as(tourParser.*)
        }

        // from all tournaments, drop the ones with ids that this team appears in
        val toReturn = filter match {
          case "-1" =>
            fetchAllTournaments.filter(tour => appearsIn.contains(tour.id)).filter(
              tour => tour.date.getTime < System.currentTimeMillis())
          case "0" => fetchAllTournaments.filter(tour => !appearsIn.contains(tour.id)).filter(
            tour => tour.date.getTime >= System.currentTimeMillis())
          case "1" => fetchAllTournaments.filter(tour => appearsIn.contains(tour.id)).filter(
            tour => tour.date.getTime >= System.currentTimeMillis())
          case _ => fetchAllTournaments
        }
        toReturn
      } else {
        fetchAllTournaments
      }
    } else {
      fetchAllTournaments
    }
  }

  def fetchTournamentDetails(tid: String): List[(Team, List[Player])] = {
    val select = SQL(s"select Tournament.t_id from Tournament where Tournament.t_id=$tid").as(int("t_id").*)
    val toReturn = select match {
      case List(x) =>
        val tourIds = SQL(s"select t.t_id from Tournament t where t.t_id=$x").as(int("t_id").*)
        // all teams in tournament
        val allTeamIds = tourIds.flatMap { tourId =>
          SQL(s"select * from tournament_team t where t.tour_id=$tourId").as(int("team_id").*)
        }
        val allTeams = allTeamIds.flatMap { teamId =>
          SQL(s"select * from teams t where t.t_id=$teamId").as(teamParser.*)
        }
        // all player ids in tour
        val allPlayers = allTeams.map {
          team => (team, SQL(s"select tp.p_id from team_players tp where tp.t_id = ${team.id}").as(int("p_id").*))
        }

        val allTeamsWithPlayers = allPlayers.map {
          team => (team._1, team._2.flatMap(
            playerId => SQL(s"select * from players where players.p_id=$playerId").as(playerParser.*)))
        }
        allTeamsWithPlayers
      case _ => List()
    }
    toReturn
  }

  def fetchMatchInfoForUser(uid: String): (Model.Tournament, Model.Match, Model.Team, Model.Team) = {
    val players = SQL(s"select players.p_id from players where players.u_id=$uid").as(int("p_id").*)
    val playersTeams = players.flatMap(
      p_id => SQL(s"select t.t_id from team_players t where t.p_id=$p_id").as(int("t_id").*))

    val tournaments = playersTeams.flatMap(
      t_id => SQL(s"select t.tour_id from tournament_team t where t.team_id=$t_id").as(int("tour_id").*)
    )
    val tournDetails = tournaments.flatMap(
      t_id => SQL(s"select * from tournament where tournament.t_id=$t_id").as(tournamentParser.*))

    val nextTourn = tournDetails.filter(_.status != -1).sortBy(_.date.getTime - System.currentTimeMillis()).head
    val teamIds = SQL(s"select t.team_id from tournament_team t where tour_id=${nextTourn.id}").as(int("team_id").*)
    val matches = SQL(s"select * from matches where matches.tour_id = ${nextTourn.id}").as(matchParser.*)

    val nextMatch = matches.filter(
      mat => mat.score1 == 0 && mat.score2 == 0 && (teamIds.contains(mat.t1_id) || teamIds.contains(mat.t2_id))).sortBy(_.id).head

    val teams = teamIds.flatMap(t_id => SQL(s"select * from teams where teams.t_id=$t_id").as(teamParser.*)).filter(
      team => team.id == nextMatch.t1_id || team.id == nextMatch.t2_id)

    val myTeam = teams.filter(team => playersTeams.contains(team.id)).head
    val otherTeam = teams.filter(_ != myTeam).head
    (nextTourn, nextMatch, myTeam, otherTeam)
  }
}
