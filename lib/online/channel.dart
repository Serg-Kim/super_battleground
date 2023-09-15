import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';

import 'package:json_patch/json_patch.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class Player {
  String name;
  Character character;

  Player({required this.name, required this.character});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      character: Character.fromJson(json['character']),
    );
  }
}

class Stats {
  num str;
  num def;
  num int;
  num luck;

  Stats({
    required this.str,
    required this.def,
    required this.int,
    required this.luck,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      str: json['str'],
      def: json['def'],
      int: json['int'],
      luck: json['luck'],
    );
  }
}

class Character {
  String type;
  Stats stats;
  int lvl;
  int point;
  int hp;
  int mp;
  int maxHp;
  int maxMp;
  int x;
  int y;

  Character({
    required this.type,
    required this.stats,
    required this.lvl,
    required this.point,
    required this.hp,
    required this.mp,
    required this.maxHp,
    required this.maxMp,
    required this.x,
    required this.y,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      type: json['type'],
      stats: Stats.fromJson(json['stats']),
      lvl: json['lvl'],
      point: json['point'],
      hp: json['hp'],
      mp: json['mp'],
      maxHp: json['max_hp'],
      maxMp: json['max_mp'],
      x: json['x'],
      y: json['y'],
    );
  }
}



class GameData {
  int iteration;
  Map<String, Player> players;

  GameData({required this.iteration, required this.players});

  factory GameData.fromJson(Map<String, dynamic> json) {
    var playersMap = json['players'] as Map<String, dynamic>;
    var players = <String, Player>{};
    playersMap.forEach((key, value) {
      players[key] = Player.fromJson(value);
    });

    return GameData(
      iteration: json['iteration'],
      players: players,
    );
  }
}


class GameConnection {
  GameConnection(this.id, this.name, this.character);

  final String id;
  final String name;
  final String character;
  late WebSocketChannel channel;
  late GameData state;
  late List<Function (GameData)> subscribers = [
  ];
  var _jsonData;

  setState (GameData newState) {
    for (var fu in subscribers) { fu(newState); }
    state = newState;
  }

  GameConnection connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.22:8080/echo?id=$id&name=$name&character=$character'),
    );

    channel.stream.listen((message) {
      var data = json.decode(message);
      if (data.runtimeType == List<dynamic>) {
        final patches = (data as Iterable).map((e) => e as Map<String, dynamic>);

        _jsonData = JsonPatch.apply(_jsonData, patches, strict: false);
        setState(GameData.fromJson(_jsonData));
        return;
      }
      _jsonData = data;
      setState(GameData.fromJson(_jsonData));
    });

    return this;
  }

  subscribe(Function (GameData) onData) {
    subscribers.add(onData);
  }
}