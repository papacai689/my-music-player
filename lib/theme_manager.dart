import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ThemeManager extends ChangeNotifier {
 String? imagePath; double opacity=.72; bool blur=false; String textMode='auto';
 Future<void> load() async { final p=await SharedPreferences.getInstance(); imagePath=p.getString('imagePath'); opacity=p.getDouble('opacity')??.72; blur=p.getBool('blur')??false; textMode=p.getString('textMode')??'auto'; notifyListeners(); }
 Future<void> save() async { final p=await SharedPreferences.getInstance(); if(imagePath==null){p.remove('imagePath');}else{p.setString('imagePath',imagePath!);} p.setDouble('opacity',opacity);p.setBool('blur',blur);p.setString('textMode',textMode); notifyListeners(); }
 Color get foregroundColor=>Colors.white.withOpacity(opacity);
 Color textColor(BuildContext c)=>textMode=='white'?Colors.white:textMode=='black'?Colors.black:Theme.of(c).colorScheme.onSurface;
 Widget backgroundWidget(){ final child=imagePath!=null?Image.file(File(imagePath!),fit:BoxFit.cover):Container(color:Colors.deepPurple.shade100); return blur?ImageFiltered(imageFilter:const ImageFilter.blur(sigmaX:12,sigmaY:12),child:child):child; }
 Future<void> setImage(String path) async { imagePath=path; await save(); }
 Future<String> copyToApp(String path) async { final dir=await getApplicationDocumentsDirectory(); final f=File('${dir.path}/background_${DateTime.now().millisecondsSinceEpoch}.jpg'); return (await File(path).copy(f.path)).path; }
 void reset() {imagePath=null;opacity=.72;blur=false;textMode='auto';save();}
}
