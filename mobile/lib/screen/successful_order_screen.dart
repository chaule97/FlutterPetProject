import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../routes.dart';

class SuccessfulOrderScreen extends StatelessWidget {
  final int orderId;

  const SuccessfulOrderScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FlutterLogo(size: 250),
              const SizedBox(height: 75),
              Text(
                '${AppLocalizations.of(context)!.order} #$orderId ${AppLocalizations.of(context)!.createSuccessfully}'.toUpperCase(),
                style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.home);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  color: Colors.deepOrange,
                  child: Text(
                    AppLocalizations.of(context)!.goBackHomePage.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}