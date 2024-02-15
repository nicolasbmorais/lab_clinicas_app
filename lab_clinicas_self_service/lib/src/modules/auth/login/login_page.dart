import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/login/login_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessageViewMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final loginController = Injector.get<LoginController>();

  @override
  void initState() {
    messageListener(loginController);
    effect(() {
      if (loginController.logged) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: sizeOf.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_login.png'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              constraints: BoxConstraints(maxWidth: sizeOf.width * .8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style: LabClinicasTheme.titleStyle,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Email',
                        ),
                      ),
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Email obrigatório'),
                          Validatorless.email('Email inválido')
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Watch(
                      (_) {
                        return TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffixIcon: IconButton(
                              onPressed: () => loginController.passwordToogle(),
                              icon: loginController.obscurePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                          obscureText: loginController.obscurePassword,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required('Senha obrigatória'),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: sizeOf.width * .8,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              loginController.login(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: const Text('ENTRAR')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
