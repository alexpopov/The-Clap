package controllers

import play.api.db.DB
import play.api.Play.current
import play.api.mvc.Controller

/**
  * Created by alan on 27/02/16.
  */
class NumBitController extends Controller {
  implicit val db = DB.getConnection("NumBits")

}
