import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/model/patient_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patients_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FindPatientController with MessageStateMixin {
  FindPatientController({
    required PatientRepository patientsRepository,
  }) : _patientsRepository = patientsRepository;

  final PatientRepository _patientsRepository;

  final _patientNotFound = ValueSignal<bool?>(null);
  final _patient = ValueSignal<PatientModel?>(null);

  bool? get patientNotFound => _patientNotFound();
  PatientModel? get patient => _patient();

  Future<void> findPatientByDocument(String document) async {
    final patientResult =
        await _patientsRepository.findPatientByDocument(document);

    bool patientNotFound;
    PatientModel? patient;

    switch (patientResult) {
      case Right(value: PatientModel model?):
        patientNotFound = false;
        patient = model;
      case Right(value: _):
        patientNotFound = true;
        patient = null;
      case Left():
        showError('Erro ao buscar paciente');
        return;
    }

    batch(() => {
          _patient.forceUpdate(patient),
          _patientNotFound.forceUpdate(patientNotFound),
        });
  }

  void continueWithoutDocument() {
    batch(() => {
          _patientNotFound.value = true,
          _patient.value = null,
        });
  }
}
