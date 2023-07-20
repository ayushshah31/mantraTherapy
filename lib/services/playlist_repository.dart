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
  Future<Map<String, String>> fetchIntroPlaylist(DateTime selectedDay);
  Future<Map<String, String>> fetchMantraSong(DateTime selectedDay);
}

class MusicPlay extends PlaylistRepository{

  MusicPlay(){
    fetch();
  }
  List<MantraModel> mantraData = [];
  dynamic tithiData = {};

  Future<void> fetch() async{
    FirebaseFetch ff = FirebaseFetch();
    mantraData = await ff.getMantraDataPro();
    tithiData = await ff.getTithiData();
    print("TithiData in music: $tithiData");
  }

  @override
  Future<Map<String, String>> fetchIntroPlaylist(DateTime selectedDay) async{
    var directory = await getApplicationDocumentsDirectory();
    var localPath = '${directory.path}${Platform.pathSeparator}download/mantra';
    int i = await _playlistNo(selectedDay);
    String introFile = "$localPath${Platform.pathSeparator}${mantraData[i].introSoundFile}";
    // String mantraFile = "$_localPath${Platform.pathSeparator}${mantraData![i].mantraSoundFile}";
    //res==15||res==30?res2.introSoundFile.toString().split(" ")[0]:res2.introSoundFile.toString().split(" ")[1],
    String selTithi = mantraData[i].tithi.toString();
    return {
      "id": selTithi,
      "title": selTithi=="15"||selTithi=="30"? mantraData[i].introSoundFile.toString().split(" ")[0]:mantraData[i].introSoundFile.toString().split(" ")[1],
      "album": "Tithi",
      "url":introFile
    };
  }

  Future<int> _playlistNo(DateTime selectedDay) async{
    print("getTithiData from playlist_repo");
    int i = 0;
    if(tithiData == null){
      var res = getTithiDate(selectedDay, tithiData);
      if(res !=30){
        i = res-1;
      } else {
        i = 15;
      }
      return i;
    } else {
      print("in else");
      await fetch();
      var res = getTithiDate(selectedDay, tithiData);
      if(res !=30){
        i = res-1;
      } else {
        i = 15;
      }
      return i;
      // i = _playlistNo(selectedDay);
    }
    return i;
  }

  @override
  Future<Map<String, String>> fetchMantraSong(DateTime selectedDay) async{
    var directory = await getApplicationDocumentsDirectory();
    var localPath = '${directory.path}${Platform.pathSeparator}download/mantra';

    // String introFile = "$_localPath${Platform.pathSeparator}${mantraData![_playlistNo()].introSoundFile}";
    int i = await _playlistNo(selectedDay);
    String mantraFile = "$localPath${Platform.pathSeparator}${mantraData[i].mantraSoundFile}";
    String selTithi = mantraData[i].tithi.toString();
    Map<String,String> retFile = {
      "id": selTithi,
      "title":  selTithi=="15"||selTithi=="30"? mantraData[i].introSoundFile.toString().split(" ")[0]:mantraData[i].introSoundFile.toString().split(" ")[1],
      "album": "Tithi",
      "url":mantraFile
    };
    print("Initial sent: $retFile");
    return retFile;
    throw UnimplementedError();
  }

}