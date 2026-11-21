import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;

  static const menus = [
    (Icons.water_drop, 'Menu 1'),
    (Icons.dashboard_outlined, 'Menu 2'),
    (Icons.build_outlined, 'Menu 3'),
    (Icons.folder_outlined, 'Menu 4'),
    (Icons.chat_bubble_outline, 'Menu 5'),
    (Icons.settings_outlined, 'Menu 6'),
  ];

  void tap(String name) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$name belum diisi')));

  Widget beranda() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Selamat datang 👋',
              style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 4),
          const Text('arvirmdnid',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menus.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2),
            itemBuilder: (_, i) => InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => tap(menus[i].$2),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF12304F),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(menus[i].$1, size: 34, color: const Color(0xFF29B6F6)),
                    const SizedBox(height: 8),
                    Text(menus[i].$2,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget placeholder(String s) => Center(child: Text(s));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: [
            beranda(),
            placeholder('Halaman Menu'),
            placeholder('Halaman Profil'),
          ][tab],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda'),
            NavigationDestination(
                icon: Icon(Icons.apps), label: 'Menu'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil'),
          ],
        ),
      );
}
