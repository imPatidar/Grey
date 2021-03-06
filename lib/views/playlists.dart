import 'dart:async';
import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/list_songs.dart';

class Playlist extends StatefulWidget {
  DatabaseClient db;
  Playlist(this.db);

  @override
  State<StatefulWidget> createState() {
    return new _StatePlaylist();
  }
}

class _StatePlaylist extends State<Playlist> {
  var mode;
  List<Song> songs;
  var selected;
  String atFirst,atSecond,atThir;
  Orientation orientation;
  @override
  void initState() {
    super.initState();
    _lengthFind();
    mode = 1;
    selected = 1;
  }

  void _lengthFind() async {
    var random = Random();
    songs = await widget.db.fetchRecentSong();
    atFirst = songs[random.nextInt(songs.length)].artist.toString();
    songs = await widget.db.fetchTopSong();
    atSecond = songs[random.nextInt(songs.length)].artist.toString();
    songs = await widget.db.fetchFavSong();
    String atThird = "No Songs in favorites";
    atThir = songs.length != 0
        ? "Includes " +
            songs[random.nextInt(songs.length)].artist.toString() +
            " and more"
        : atThird;
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Container(
      child: orientation == Orientation.portrait ? potrait() : landscape(),
    );
  }

  Widget potrait() {
    return new ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        new ListTile(
          leading: new Icon(
            Icons.history,
            size: 28.0,
          ),
          title: new Text(
            "Recently played",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                fontFamily: "Quicksand"),
          ),
          subtitle: new Text(
            "Includes " + atFirst + " and more",
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 1, orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(
            Icons.insert_chart,
            size: 28.0,
          ),
          title: new Text(
            "Top tracks",
            style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 1.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500),
          ),
          subtitle: new Text(
            "Includes " + atSecond + " and more",
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 2, orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(
            Icons.favorite,
            size: 28.0,
          ),
          title: new Text(
            "Favourites",
            style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 1.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500),
          ),
          subtitle: new Text(
            atThir,
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 3, orientation);
            }));
          },
        ),
      ],
    );
  }

  Widget landscape() {
    return new Row(
      children: <Widget>[
        new Container(
          width: 300.0,
          child: new ListView(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.call_received),
                title: new Text("Recently played",
                    style: new TextStyle(
                        color: selected == 1 ? Colors.blue : Colors.black)),
                subtitle: new Text("songs"),
                onTap: () {
                  setState(() {
                    mode = 1;
                    selected = 1;
                  });
                },
              ),
              new ListTile(
                leading: new Icon(Icons.show_chart),
                title: new Text("Top tracks",
                    style: new TextStyle(
                        color: selected == 2 ? Colors.blue : Colors.black)),
                subtitle: new Text("songs"),
                onTap: () {
                  setState(() {
                    mode = 2;
                    selected = 2;
                  });
                },
              ),
              new ListTile(
                leading: new Icon(Icons.favorite),
                title: new Text("Favourites",
                    style: new TextStyle(
                        color: selected == 3 ? Colors.blue : Colors.black)),
                subtitle: new Text("Songs"),
                onTap: () {
                  setState(() {
                    mode = 3;
                    selected = 3;
                  });
                },
              ),
            ],
          ),
        ),
        new Expanded(
            child: new Container(
          child: new ListSongs(widget.db, mode, orientation),
        ))
      ],
    );
  }
}
