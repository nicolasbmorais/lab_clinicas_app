import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/documents_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan/documents_scan_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/done/done_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/find_patient/find_patient_router.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patients/patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patients/patient_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/who_i_am/who_i_am_page.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patients_repository.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patients_repository_impl.dart';

class SelfServiceModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<SelfServiceController>(
          (i) => SelfServiceController(),
        ),
        Bind.lazySingleton<PatientRepository>(
          (i) => PatientsRepositoryImpl(restClient: i()),
        ),
        Bind.lazySingleton<PatientController>(
          (i) => PatientController(repository: i()),
        ),
      ];

  @override
  String get moduleRouteName => '/self-service';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/': (context) => const SelfServicePage(),
        '/whoIAm': (context) => const WhoIAmPage(),
        '/find-patient': (context) => const FindPatientRouter(),
        '/patient': (context) => const PatientPage(),
        '/documents': (context) => const DocumentsPage(),
        '/documents/scan': (context) => const DocumentsScanPage(),
        '/documents/scan/confirm': (context) =>
            const DocumentsScanConfirmPage(),
        '/done': (context) => const DonePage(),
      };
}
