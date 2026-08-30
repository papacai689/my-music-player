import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'theme_manager.dart';
import 'player_controller.dart';
import 'download_service.dart';

class DiscoverPage extends StatelessWidget { const DiscoverPage({super.key}); @override Widget build(BuildContext c)=>_SimplePage(title:'发现', icon:Icons.explore, child:Column(children:[TextField(decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'搜索歌曲、歌手或歌单'),onSubmitted:(_){ }), const SizedBox(height:24),const Text('推荐内容将在连接网易云 API 后显示') ])); }
class LocalPage extends StatefulWidget { const LocalPage({super.key}); @override State<LocalPage> createState()=>_LocalState(); }
class _LocalState extends State<LocalPage>{ final tracks=<Track>[]; bool scanning=false; Future scan() async {setState(()=>scanning=true); await Future.delayed(const Duration(milliseconds:400)); setState(()=>scanning=false);} @override Widget build(BuildContext c)=>_SimplePage(title:'本地音乐',icon:Icons.library_music,child:Column(children:[Align(alignment:Alignment.centerRight,child:FilledButton.icon(onPressed:scanning?null:scan,icon:const Icon(Icons.refresh),label:Text(scanning?'扫描中':'扫描'))),Expanded(child:tracks.isEmpty?const Center(child:Text('暂无本地音乐，请点击扫描')):ListView.builder(itemCount:tracks.length,itemBuilder:(_,i){final t=tracks[i];return ListTile(title:Text(t.title),subtitle:Text(t.artist),onTap:()=>c.read<PlayerController>().play(t));}))])); }
class DownloadsPage extends StatelessWidget { const DownloadsPage({super.key}); @override Widget build(BuildContext c)=>Consumer<DownloadService>(builder:(_,s,__){final all=s.tasks.values.toList(); return _SimplePage(title:'下载管理',icon:Icons.download,child:all.isEmpty?const Center(child:Text('暂无下载任务')):ListView.builder(itemCount:all.length,itemBuilder:(_,i){final t=all[i];return ListTile(title:Text(t.title),subtitle:t.path!=null?const Text('已完成'):LinearProgressIndicator(value:t.progress),trailing:IconButton(icon:Icon(t.path!=null?Icons.delete:Icons.close),onPressed:()=>t.path!=null?s.remove(t.id):s.cancel(t.id)));}));}); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext c)=>_SimplePage(title:'我的',icon:Icons.person,child:Center(child:FilledButton.icon(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const ThemeSettingsPage())),icon:const Icon(Icons.palette),label:const Text('主题设置')))); }
class ThemeSettingsPage extends StatefulWidget { const ThemeSettingsPage({super.key}); @override State<ThemeSettingsPage> createState()=>_ThemeSettingsState(); }
class _ThemeSettingsState extends State<ThemeSettingsPage>{ @override Widget build(BuildContext c){final tm=c.watch<ThemeManager>();return Scaffold(appBar:AppBar(title:const Text('主题设置')),body:ListView(padding:const EdgeInsets.all(20),children:[SwitchListTile(title:const Text('背景模糊'),value:tm.blur,onChanged:(v){tm.blur=v;tm.save();}),Text('前景透明度 ${(tm.opacity*100).round()}%'),Slider(value:tm.opacity,min:.1,max:1,onChanged:(v){tm.opacity=v;tm.save();}),DropdownButton<String>(value:tm.textMode,items:const [DropdownMenuItem(value:'auto',child:Text('自动文字颜色')),DropdownMenuItem(value:'black',child:Text('黑色文字')),DropdownMenuItem(value:'white',child:Text('白色文字'))],onChanged:(v){if(v!=null){tm.textMode=v;tm.save();}}),FilledButton.icon(onPressed:() async {final x=await ImagePicker().pickImage(source:ImageSource.gallery);if(x!=null){final p=await tm.copyToApp(x.path);await tm.setImage(p);}},icon:const Icon(Icons.image),label:const Text('选择背景图片')),OutlinedButton(onPressed:tm.reset,child:const Text('恢复默认'))]));} }
class _SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SimplePage({required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext c) {
    final tm = c.watch<ThemeManager>();
    final fg = tm.textColor(c);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: fg), const SizedBox(width: 8), Text(title, style: Theme.of(c).textTheme.headlineSmall?.copyWith(color: fg))]),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: tm.foregroundColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(style: TextStyle(color: fg), child: child),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}
class MiniPlayer extends StatelessWidget { const MiniPlayer({super.key}); @override Widget build(BuildContext c)=>Consumer<PlayerController>(builder:(_,p,__){if(p.current==null)return const SizedBox(height:8);return ListTile(title:Text(p.current!.title),subtitle:Text(p.current!.artist),leading:const Icon(Icons.music_note),trailing:IconButton(icon:Icon(Icons.play_arrow),onPressed:p.toggle));}); }

class PlaylistDetailPage extends StatelessWidget { final String playlistId; const PlaylistDetailPage({super.key,required this.playlistId}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('歌单详情')),body:const Center(child:Text('歌单信息与歌曲列表'))); }
class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});
  @override
  Widget build(BuildContext c) => Consumer<PlayerController>(
    builder: (_, p, __) {
      final t = p.current;
      if (t == null) return const Scaffold(body: Center(child: Text('暂无歌曲')));
      return Scaffold(
        appBar: AppBar(title: const Text('正在播放')),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.album, size: 180),
          Text(t.title),
          Text(t.artist),
          IconButton(icon: const Icon(Icons.play_arrow, size: 64), onPressed: p.toggle),
        ]),
      );
    },
  );
}
