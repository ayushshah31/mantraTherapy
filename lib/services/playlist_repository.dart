import 'package:calendarsong/model/mantraData.dart';
import 'package:calendarsong/providers/mantraDataProvider.dart';
import 'package:calendarsong/providers/tithiDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/common.dart';
import '../model/tithiData.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:calendarsong/data/FirebaseFetch.dart';

abstract class PlaylistRepository {
  Future<Map<String, String>> fetchIntroPlaylist(int tithiNo);
  Future<Map<String, String>> fetchMantraSong(int tithiNo);
}

class MusicPlay extends PlaylistRepository {
  MusicPlay() {
    fetch();
  }
  List<MantraModel> mantraData = [];
  dynamic tithiData = {};

  Future<void> fetch() async {
    FirebaseFetch ff = FirebaseFetch();
    mantraData = await ff.getMantraDataPro();
    tithiData = await ff.getTithiData();
    // print("TithiData in music: $tithiData");
  }

  @override
  Future<Map<String, String>> fetchIntroPlaylist(int tithiNo) async {
    var directory = await getApplicationDocumentsDirectory();
    var localPath = 'file://${directory.path}${Platform.pathSeparator}download/mantra';
    int i;
    if (tithiNo == -1) {
      i = await _playlistDate(DateTime.now());
    } else {
      i = await _playlistNo(tithiNo);
    }
    String introFile = "$localPath${Platform.pathSeparator}${mantraData[i].introSoundFile}";
    File file = File(introFile);
    // String mantraFile = "$_localPath${Platform.pathSeparator}${mantraData![i].mantraSoundFile}";
    //res==15||res==30?res2.introSoundFile.toString().split(" ")[0]:res2.introSoundFile.toString().split(" ")[1],
    String selTithi = mantraData[i].tithi.toString();
    return {
      "id": selTithi,
      "title": selTithi == "15" || selTithi == "30"
          ? mantraData[i].introSoundFile.toString().split(" ")[0]
          : mantraData[i].introSoundFile.toString().split(" ")[1],
      "album": "Tithi",
      "url": file.path
    };
  }

  Future<int> _playlistNo(int tithiNo) async {
    print("getTithiData from playlist_repo no");
    int i = 0;
    print("tithiData123: $tithiData");
    if (tithiData.length != 0) {
      print("why here no");
      // var res = getTithiDate(selectedDay, tithiData);
      var res = tithiNo;
      if (res != 30) {
        i = res - 1;
      } else {
        i = 15;
      }
      return i;
    } else {
      print("in else");
      await fetch();
      // var res = getTithiDate(selectedDay, tithiData);
      var res = tithiNo;
      if (res != 30) {
        i = res - 1;
      } else {
        i = 15;
      }
      return i;
      // i = _playlistNo(selectedDay);
    }
    return i;
  }

  Future<int> _playlistDate(DateTime selectedDate) async {
    print("getTithiData from playlist_repo Date");
    int i = 0;
    print("tithiData: $tithiData");
    if (tithiData.length != 0) {
      print("why here date");
      var res = getTithiDate(selectedDate, tithiData);
      // var res = tithiNo;
      if (res != 30) {
        i = res - 1;
      } else {
        i = 15;
      }
      return i;
    } else {
      print("in else");
      await fetch();
      var res = getTithiDate(selectedDate, tithiData);
      // var res = tithiNo;
      if (res != 30) {
        i = res - 1;
      } else {
        i = 15;
      }
      return i;
      // i = _playlistNo(selectedDay);
    }
    return i;
  }

  @override
  Future<Map<String, String>> fetchMantraSong(int tithiNo) async {
    var directory = await getApplicationDocumentsDirectory();
    var localPath = '${directory.path}${Platform.pathSeparator}download/mantra';

    // String introFile = "$_localPath${Platform.pathSeparator}${mantraData![_playlistNo()].introSoundFile}";
    int i;
    if (tithiNo == -1) {
      i = await _playlistDate(DateTime.now());
    } else {
      i = await _playlistNo(tithiNo);
    }
    String mantraFile =
        "file://$localPath${Platform.pathSeparator}${mantraData[i].mantraSoundFile}";
    String selTithi = mantraData[i].tithi.toString();
    Map<String, String> retFile = {
      "id": selTithi,
      "title": selTithi == "15" || selTithi == "30"
          ? mantraData[i].introSoundFile.toString().split(" ")[0]
          : mantraData[i].introSoundFile.toString().split(" ")[1],
      "album": "Tithi",
      "url": mantraFile
    };
    print("Initial sent: $retFile");
    return retFile;
    throw UnimplementedError();
  }
}
