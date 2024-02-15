import 'package:flutter/material.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: LabClinicasAppbar(
        actions: [
          PopupMenuButton(
            child: const IconPopMenuWidget(),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Iniciar Terminal'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Finalizar Terminal'),
                )
              ];
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 112),
          padding: const EdgeInsets.all(40),
          width: sizeOf.width * .8,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: LabClinicasTheme.orangeColor,
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bem Vindo!',
                style: LabClinicasTheme.titleStyle,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: sizeOf.width * .8,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/self-service');
                  },
                  child: const Text('INICIAR TERMINAL'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
