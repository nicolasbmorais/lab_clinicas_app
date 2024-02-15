import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';

class WhoIAmPage extends StatefulWidget {
  const WhoIAmPage({super.key});

  @override
  State<WhoIAmPage> createState() => _WhoIAmPageState();
}

class _WhoIAmPageState extends State<WhoIAmPage> {
  final formKey = GlobalKey<FormState>();
  final fisrtNameEC = TextEditingController();
  final lastNameEC = TextEditingController();
  final selfServiceController = Injector.get<SelfServiceController>();

  @override
  void dispose() {
    super.dispose();
    fisrtNameEC.dispose();
    lastNameEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        fisrtNameEC.text = '';
        lastNameEC.text = '';
        selfServiceController.clearForm();
      },
      child: Scaffold(
        appBar: LabClinicasAppbar(
          actions: [
            PopupMenuButton(
              child: const IconPopMenuWidget(),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Finalizar Terminal'),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 1) {
                  await SharedPreferences.getInstance()
                      .then((sp) => sp.clear());
                  if (mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                }
              },
            ),
          ],
        ),
        body: LayoutBuilder(builder: (_, constrains) {
          var mediaQuery = MediaQuery.sizeOf(context);
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: constrains.maxHeight),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/background_login.png',
                  ),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  width: mediaQuery.width * .8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo_vertical.png'),
                        const Text(
                          'Bem-Vindo!',
                          style: LabClinicasTheme.titleStyle,
                        ),
                        const SizedBox(height: 48),
                        TextFormField(
                          controller: fisrtNameEC,
                          validator: Validatorless.required('Nome obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Digite o seu nome'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: lastNameEC,
                          validator:
                              Validatorless.required('Sobrenome obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Digite o seu nome'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: mediaQuery.width * .8,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                selfServiceController.setWhoIAmDataStepAndNext(
                                    fisrtNameEC.text, lastNameEC.text);
                              }
                            },
                            child: const Text('CONTINUAR'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
