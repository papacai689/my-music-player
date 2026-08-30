import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';
import 'player_controller.dart';
import 'download_service.dart';
import 'pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = ThemeManager();
  await theme.load();
  await DownloadService.instance.init();
  runApp(MultiProvider(providers: [ChangeNotifierProvider.value(value: theme), ChangeNotifierProvider(create: (_) => PlayerController()), ChangeNotifierProvider.value(value: DownloadService.instance)], child: const MyMusicApp()));
}

class MyMusicApp extends StatelessWidget { const MyMusicApp({super.key});
  @override Widget build(BuildContext context) => Consumer<ThemeManager>(builder: (_, tm, __) => MaterialApp(debugShowCheckedModeBanner: false, title: 'My Music', theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), scaffoldBackgroundColor: Colors.transparent), home: const AppShell()));
}

class AppShell extends StatefulWidget { const AppShell({super.key}); @override State<AppShell> createState()=>_AppShellState(); }
class _AppShellState extends State<AppShell> { int index=0; final pages=const [DiscoverPage(),LocalPage(),DownloadsPage(),ProfilePage()];
 @override Widget build(BuildContext context){ final tm=context.watch<ThemeManager>(); final fg=tm.textColor(context); return Stack(children:[Positioned.fill(child: tm.backgroundWidget()), Scaffold(backgroundColor: Colors.transparent, body: SafeArea(child: pages[index]), bottomNavigationBar: Theme(data: Theme.of(context).copyWith(canvasColor: tm.foregroundColor), child: NavigationBar(selectedIndex:index,onDestinationSelected:(i)=>setState(()=>index=i), destinations:[NavigationDestination(icon:Icon(Icons.explore,color:fg),label:'发现'),NavigationDestination(icon:Icon(Icons.library_music,color:fg),label:'本地'),NavigationDestination(icon:Icon(Icons.download,color:fg),label:'下载'),NavigationDestination(icon:Icon(Icons.person,color:fg),label:'我的')])))]); }
}

