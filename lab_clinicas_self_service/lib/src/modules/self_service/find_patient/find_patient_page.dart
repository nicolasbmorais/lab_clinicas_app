import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/find_patient/find_patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/widgets/self_service_appbar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class FindPatientPage extends StatefulWidget {
  const FindPatientPage({super.key});

  @override
  State<FindPatientPage> createState() => _FindPatientPageState();
}

class _FindPatientPageState extends State<FindPatientPage>
    with MessageViewMixin {
  final formKey = GlobalKey<FormState>();
  final documentEC = TextEditingController();
  final controller = Injector.get<FindPatientController>();

  @override
  void initState() {
    super.initState();
    messageListener(controller);
    effect(() {
      final FindPatientController(:patient, :patientNotFound) = controller;

      if (patient != null || patientNotFound != null) {
        Injector.get<SelfServiceController>().goToFormPatient(patient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SelfServiceAppbar(),
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
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: documentEC,
                        validator: Validatorless.required('CPF Obrigatório'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          label: Text('Digite o CPF do paciente'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            const Text(
                              'Não sabe seu CPF?',
                              style: TextStyle(
                                fontSize: 14,
                                color: LabClinicasTheme.blueColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                'Clique aqui',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LabClinicasTheme.orangeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                controller.continueWithoutDocument();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery.width * .8,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.findPatientByDocument(documentEC.text);
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
    );
  }
}
