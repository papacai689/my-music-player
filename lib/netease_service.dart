import 'dart:convert';
import 'package:http/http.dart' as http;
import 'player_controller.dart';
class NeteaseService { static const base='http://localhost:3000'; Future<List<Track>> newSongs() async { final r=await http.get(Uri.parse('$base/top/song?type=0')); if(r.statusCode!=200)return []; final data=jsonDecode(r.body)['data'] as List? ?? []; return data.take(30).map((e)=>Track(id:'${e['id']}',title:e['name']??'',artist:(e['artists'] as List? ?? []).map((a)=>a['name']).join(', '),url:'$base/song/url?id=${e['id']}')).toList(); } }
