import 'package:mysql_client/mysql_client.dart';

class Exam
{
  int id;
  String type;
  DateTime datetime;

  Exam(this.id, this.type, this.datetime);
}

class Location
{
  String roomCode;
  String? roomName;
  String buildingName;

  Location(this.roomCode, this.roomName, this.buildingName);
}

class DatabaseManager
{
  static MySQLConnection? _connection;
  static bool get connected => _connection?.connected ?? false;

  DatabaseManager._();

  static Future<bool> connect(Uri databaseUri) async {
    _connection = await MySQLConnection.createConnection(
      host: databaseUri.host,
      port: databaseUri.port,
      userName: "canvasconnect",
      password: "canvasconnect",
      secure: false
    );

    await _connection!.connect();

    if (!_connection!.connected) {
      return false;
    }

    /* Select database */
    await _connection!.execute("use canvas_connect;");

    return true;
  }

  static Future<List<Exam>> getExams(String courseCode) async
  {
    List<Exam> exams = [];

    if (_connection == null || !_connection!.connected) {
      throw Exception("Not connected");
    }

    var result = await _connection!.execute(
      """
      select id, type, date_time from exam
      where INSTR("$courseCode", course_code);
      """
    );

    for (var row in result.rows) {
      var values = row.assoc();

      exams.add(Exam(int.parse(values["id"]!), values["type"]!, DateTime.parse(values["date_time"]!)));
    }

    return exams;
  }

  static Future<List<Location>> getExamLocations(int examId) async {
    List<Location> locations = [];

    if (_connection == null || !_connection!.connected) {
      throw Exception("Not connected");
    }

    var result = await _connection!.execute(
      """
      select code, room.name as room_name, building.name as building_name from exam_location
      inner join exam on exam_location.exam_id = exam.id
      inner join room on exam_location.room_id = room.id
      inner join building on room.building_id = building.id
      where exam_id = $examId;
      """
    );

    for (var row in result.rows) {
      var values = row.assoc();

      locations.add(Location(values["code"]!, values["room_name"], values["building_name"]!));
    }

    return locations;
  }
}
