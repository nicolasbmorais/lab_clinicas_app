import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/src/theme/lab_clinicas_theme.dart';

class LabClinicasCoreConfig extends StatelessWidget {
  final ApplicationBindings? bindings;
  final List<FlutterGetItPageRouter>? pages;
  final List<FlutterGetItPageBuilder>? pagesBuilders;
  final List<FlutterGetItModule>? modules;
  final String title;

  const LabClinicasCoreConfig({
    super.key,
    required this.title,
    this.bindings,
    this.pages,
    this.pagesBuilders,
    this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      debugMode: kDebugMode,
      bindings: bindings,
      pages: [...pages ?? [], ...pagesBuilders ?? []],
      modules: modules,
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(
          builder: (navigatorObserver) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: LabClinicasTheme.lightTheme,
              darkTheme: LabClinicasTheme.darkTheme,
              navigatorObservers: [
                navigatorObserver,
                flutterGetItNavObserver,
              ],
              routes: routes,
              title: title,
            );
          },
        );
      },
    );
  }
}
