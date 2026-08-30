import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
class DownloadTask extends ChangeNotifier { final String id,title,url; double progress=0; String? path; bool downloading=false,paused=false; CancelToken? token; DownloadTask({required this.id,required this.title,required this.url}); }
class DownloadService extends ChangeNotifier { static final instance=DownloadService._(); DownloadService._(); final tasks=<String,DownloadTask>{}; final dio=Dio(); Future<void> init() async{} 
 Future<void> download(String id,String title,String url) async { final t=tasks.putIfAbsent(id,()=>DownloadTask(id:id,title:title,url:url)); t.downloading=true;t.paused=false;t.token=CancelToken(); notifyListeners(); final dir=await getApplicationDocumentsDirectory(); try{ final path='${dir.path}/$id.mp3'; await dio.download(url,path,cancelToken:t.token,onReceiveProgress:(a,b){if(b>0)t.progress=a/b;notifyListeners();}); t.path=path;t.downloading=false;notifyListeners(); }catch(_){t.downloading=false;notifyListeners();} }
 void cancel(String id){tasks[id]?.token?.cancel();tasks[id]?.downloading=false;notifyListeners();} void remove(String id){tasks.remove(id);notifyListeners();}
}
