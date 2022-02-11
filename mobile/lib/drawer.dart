import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom ({Key? key}) : super(key: key);

  final drawerHeader = const UserAccountsDrawerHeader(
    accountName: Text("Le Bao Chau"),
    accountEmail: Text("lebaochau97@gmail.com"),
    currentAccountPicture: CircleAvatar(
      child: FlutterLogo(size: 42.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text(AppLocalizations.of(context)!.homePage),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.shoe),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.clothes),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.accessory),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    return Drawer(
      child: drawerItems,
    );
  }

}