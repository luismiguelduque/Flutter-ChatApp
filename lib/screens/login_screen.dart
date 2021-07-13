import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../helpers/show_alert.dart';
import '../services/auth_service.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: "Messenger",),
                _Form(),
                Labels(
                  route: "register",
                  title: "¿No tienes cuenta?",
                  linkText: "Crea una ahora",
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Términos y condiciones de uso",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomTextfield(
            icon: Icons.mail_outline,
            placeholder: "Email",
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomTextfield(
            icon: Icons.lock_outline,
            placeholder: "Password",
            keyboardType: TextInputType.text,
            obscureText: true,
            textController: passwordCtrl,
          ),
          CustomElevatedButton(
            text: "Login",
            disabled: authService.authenticating,
            onPressed:  () async {
              FocusScope.of(context).unfocus();
              final loginStatus = await authService.login(emailCtrl.text.trim(), passwordCtrl.text.trim());
              if(loginStatus){
                Navigator.of(context).pushReplacementNamed("users");
              }else{
                showAlert(context, "Login error", "Not valid credentials");
              }
            }
          )
        ],
      ),
    );
  }
}
