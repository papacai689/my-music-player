import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
class Track { final String id,title,artist,cover; final String? url,filePath; Track({required this.id,required this.title,required this.artist,this.cover='',this.url,this.filePath}); }
class PlayerController extends ChangeNotifier { final AudioPlayer audio=AudioPlayer(); Track? current; bool playing=false; Duration position=Duration.zero,duration=Duration.zero;
 PlayerController(){audio.playerStateStream.listen((s){playing=s.playing;notifyListeners();});audio.positionStream.listen((p){position=p;notifyListeners();});audio.durationStream.listen((d){duration=d??Duration.zero;notifyListeners();});}
 Future<void> play(Track t) async {current=t; try{await audio.setAudioSource(t.filePath!=null?AudioSource.file(t.filePath!):AudioSource.uri(Uri.parse(t.url!)));await audio.play();}catch(_){ } notifyListeners();}
 Future<void> toggle() async=>playing?audio.pause():audio.play(); Future<void> seek(Duration p)=>audio.seek(p); Future<void> disposePlayer() async=>audio.dispose();
}
