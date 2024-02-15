import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/model/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patients/patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patients/patient_form_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/widgets/self_service_appbar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage>
    with PatientFormController, MessageViewMixin {
  final formKey = GlobalKey<FormState>();
  final SelfServiceController selfServiceController =
      Injector.get<SelfServiceController>();

  final PatientController controller = Injector.get<PatientController>();

  late bool patientFound;
  late bool enableForm;

  @override
  void initState() {
    super.initState();

    messageListener(controller);

    final SelfServiceModel(:patient) = selfServiceController.model;
    patientFound = patient != null;
    enableForm = !patientFound;

    initializeForm(patient);

    effect(() => {
          if (controller.nextStep)
            {
              selfServiceController
                  .updatePatientAndGoDocument(controller.patient)
            }
        });
  }

  @override
  void dispose() {
    super.dispose();
    disposeForm();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: SelfServiceAppbar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: sizeOf * .85,
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: LabClinicasTheme.orangeColor),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Visibility(
                    visible: patientFound,
                    replacement: Image.asset('assets/images/lupa_icon.png'),
                    child: Image.asset('assets/images/check_icon.png'),
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: patientFound,
                    replacement: const Text(
                      'Cadastro não encontrado',
                      style: LabClinicasTheme.titleSmallStyle,
                    ),
                    child: const Text(
                      'Cadastro encontrado',
                      style: LabClinicasTheme.titleSmallStyle,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Visibility(
                    visible: patientFound,
                    replacement: const Text(
                      'Preencha o formulário abaixo para fazer o seu cadastro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: LabClinicasTheme.blueColor,
                      ),
                    ),
                    child: const Text(
                      'Confirmar os dados do seu cadastro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: LabClinicasTheme.blueColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: nameEC,
                    validator: Validatorless.required('Nome obrigatório'),
                    decoration: const InputDecoration(
                      label: Text('Nome do paciente'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required('Nome obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: phoneEC,
                    validator: Validatorless.required('Telefone obrigatório'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      label: Text('Telefone de contato'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: documentEC,
                    validator: Validatorless.required('CPF obrigatório'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      label: Text('Digite o seu CPF'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: cepEC,
                    validator: Validatorless.required('CEP obrigatório'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                        label: Text('CEP'),
                        suffixIcon: Icon(
                          Icons.search,
                          color: LabClinicasTheme.orangeColor,
                        )),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: streetEC,
                          validator:
                              Validatorless.required('Endereço obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Endereço'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: numberEC,
                          validator:
                              Validatorless.required('Número obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Número'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: complementEC,
                          decoration: const InputDecoration(
                            label: Text('Complemento'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: stateEC,
                          validator:
                              Validatorless.required('Estado obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Estado'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: cityEC,
                          validator:
                              Validatorless.required('Cidade obrigatória'),
                          decoration: const InputDecoration(
                            label: Text('Cidade'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: districtEC,
                          validator:
                              Validatorless.required('Bairro obrigatório'),
                          decoration: const InputDecoration(
                            label: Text('Bairro'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: guardianEC,
                    decoration: const InputDecoration(
                      label: Text('Responsável'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: guardianIdentificationNumberEC,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      label: Text('Documento de identificação'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Visibility(
                    visible: !enableForm,
                    replacement: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            if (patientFound) {
                              controller.updateAndNext(updatePatient(
                                  selfServiceController.model.patient!));
                            } else {
                              controller.saveAndNext(createPatientRegister());
                            }
                          }
                        },
                        child: Visibility(
                            visible: !patientFound,
                            replacement: const Text('SALVAR E CONTINUAR'),
                            child: const Text('CADASTRAR')),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  enableForm = true;
                                });
                              },
                              child: const Text('EDITAR'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.patient =
                                    selfServiceController.model.patient;
                                controller.goNextStep();
                              },
                              child: const Text('CONTINUAR'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
