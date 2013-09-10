import 'package:mongo_dart/mongo_dart.dart';
import 'User.dart';
import "dart:mirrors";
import "dart:json";

Map serialize(var object){
  var instanceMirror = reflect(object);
  var classMirror = instanceMirror.type;
  
  var map = classMirror.variables;
  var json = new Map();
  
  map.keys.forEach((v) {
    var key = MirrorSystem.getName(v);
    var value = instanceMirror.getField(v).reflectee; 
    json[key] = value;
  });
  
  return json;
}



void main() {
  
  User a = new User("Biagio", "Chirico", "Neuro"); 
  
  Db db = new Db("mongodb://127.0.0.1/mirror_example");
  db.open().then((_){
    print("Starting connection with mongoDB...");

    DbCollection collezione;
    collezione = db.collection("utenti");
    collezione.save(serialize(a));
      
    db.close();
    print("Connection closed");
  });
}
