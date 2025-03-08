import 'package:blog_app/core/common/widgets/custom_loading_indicator.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_footer.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Key to validate the sign up form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Text editing controllers for fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  showSnackBar(context, state.user.email);
                } else if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CustomLoadingIndicator();
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Sign up.',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ),
                      AuthField(
                          hintText: 'Name',
                          textEditingController: nameController),
                      AuthField(
                          hintText: 'Email',
                          textEditingController: emailController),
                      AuthField(
                        hintText: 'Password',
                        textEditingController: passwordController,
                        isObscured: true,
                      ),
                      AuthGradientButton(
                        buttonText: 'Sign up',
                        onPressed: () {
                          _formKey.currentState!.validate()
                              ? context.read<AuthBloc>().add(AuthSignUp(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()))
                              : null;
                        },
                      ),
                      AuthFooter(
                          isSignUp: true,
                          onTap: () {
                            context.go('/sign-in');
                          })
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
