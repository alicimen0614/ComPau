import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/widgets/elevated_button_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_text_form_field.dart';

enum FormStatus { signIn, register, reset }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final signInFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerPasswordConfirmController =
      TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  FormStatus formStatus = FormStatus.signIn;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
          child: SizedBox(
            height: context.height - 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 4),
                Expanded(
                    flex: 2,
                    child: Text(
                      formStatus == FormStatus.signIn
                          ? "Merhaba!"
                          : formStatus == FormStatus.register
                              ? "Hesabını oluştur"
                              : "Şifremi unuttum",
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.start,
                    )),
                // Expanded(
                //     flex: formStatus == FormStatus.signIn ? 2 : 0,
                //     child: formStatus == FormStatus.signIn
                //         ? Text(
                //             "Hoşgeldin, giriş yapmak için e-posta adresini ve şifreni kullan.",
                //             style: TextStyle(color: Colors.grey[500]))
                //         : const SizedBox.shrink()),
                const Spacer(flex: 2),
                formStatus == FormStatus.register
                    ? Expanded(flex: 20, child: registerForm())
                    : formStatus == FormStatus.signIn
                        ? Expanded(flex: 15, child: signInForm())
                        : Expanded(flex: 15, child: resetForm()),
              ],
            ),
          ),
        )));
  }

  Form signInForm() {
    return Form(
      key: signInFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                      bottom: Radius.circular(10),
                    )),
                child: Center(
                  child: CustomTextFormField(
                    validator: (value) {
                      if (EmailValidator.validate(value!)) {
                        return null;
                      } else {
                        return 'Lütfen geçerli bir E-posta adresi giriniz.';
                      }
                    },
                    textEditingController: signInEmailController,
                    autoCorrect: true,
                    textInputType: TextInputType.emailAddress,
                    prefixIconData: Icons.account_circle,
                    useSuffixIcon: false,
                    label: 'Email',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(25),
                    )),
                child: Center(
                  child: CustomTextFormField(
                    validator: (value) {
                      if (value!.length < 6 || value.length > 16) {
                        return "Şifreniz 6-16 karakter arasında olmalıdır";
                      } else {
                        return null;
                      }
                    },
                    textEditingController: signInPasswordController,
                    obscureText: true,
                    autoCorrect: true,
                    textInputType: TextInputType.emailAddress,
                    prefixIconData: Icons.lock,
                    useSuffixIcon: true,
                    label: 'Şifre',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        formStatus = FormStatus.reset;
                      });
                    },
                    child: Text(
                      "Şifremi Unuttum",
                      style: context.textTheme.bodyMedium,
                    )),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
                flex: 3,
                child: CustomElevatedButton(
                  btnTitle: 'Giriş Yap',
                  onPressed: () {},
                  borderRadius: 50,
                )),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    endIndent: 5,
                  )),
                  googleSignIn(),
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    indent: 5,
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Üye değil misin?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          formStatus = FormStatus.register;
                        });
                      },
                      child: Text(
                        "Üye Ol",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Form registerForm() {
    return Form(
      key: registerFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                validator: (value) {
                  if (EmailValidator.validate(value!)) {
                    return null;
                  } else {
                    return 'Lütfen geçerli bir E-posta adresi giriniz.';
                  }
                },
                textEditingController: registerEmailController,
                autoCorrect: true,
                textInputType: TextInputType.emailAddress,
                prefixIconData: Icons.account_circle,
                label: 'Email',
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                validator: (value) {
                  if (value!.length < 6 || value.length > 16) {
                    return "Şifreniz 6-16 karakter arasında olmalıdır";
                  } else if (value != registerPasswordConfirmController.text) {
                    return 'Şifreler Uyuşmuyor';
                  } else if (value.contains(" ")) {
                    return "Şifrede boşluk olamaz.";
                  } else {
                    return null;
                  }
                },
                textEditingController: registerPasswordController,
                obscureText: true,
                autoCorrect: true,
                textInputType: TextInputType.emailAddress,
                prefixIconData: Icons.lock,
                useSuffixIcon: true,
                label: 'Şifre',
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                validator: (value) {
                  if (value!.length < 6 || value.length > 16) {
                    return "Şifreniz 6-16 karakter arasında olmalıdır";
                  } else if (value != registerPasswordConfirmController.text) {
                    return 'Şifreler Uyuşmuyor';
                  } else if (value.contains(" ")) {
                    return "Şifrede boşluk olamaz.";
                  } else {
                    return null;
                  }
                },
                textEditingController: registerPasswordConfirmController,
                obscureText: true,
                autoCorrect: true,
                textInputType: TextInputType.emailAddress,
                prefixIconData: Icons.lock,
                useSuffixIcon: true,
                label: 'Şifre Tekrar',
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  onPressed: () async {
                    /* if (registerFormKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ));
                      await authService
                          .createUserWithEmailAndPassword(
                              registerEmailController.text,
                              registerPasswordController.text,
                              context)
                          .then((value) {
                        if (value != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavBarBuilder(),
                              ),
                              (route) => false);
                        } else {
                          Navigator.pop(context);
                        }
                      });
                    } */
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    endIndent: 5,
                  )),
                  googleSignIn(),
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    indent: 5,
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Zaten üye misin?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          formStatus = FormStatus.signIn;
                        });
                      },
                      child: Text(
                        "Giriş Yap",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Form resetForm() {
    return Form(
      key: resetFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: CustomTextFormField(
                validator: (value) {
                  if (EmailValidator.validate(value!)) {
                    return null;
                  } else {
                    return "Lütfen geçerli bir e-mail adresi giriniz";
                  }
                },
                textEditingController: resetEmailController,
                autoCorrect: true,
                textInputType: TextInputType.emailAddress,
                prefixIconData: Icons.account_circle,
                label: 'Email',
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    "Gönder",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    endIndent: 5,
                  )),
                  googleSignIn(),
                  const Expanded(
                      child: Divider(
                    color: Colors.black38,
                    indent: 5,
                  )),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Şifreni hatırladın mı?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          formStatus = FormStatus.signIn;
                        });
                      },
                      child: Text(
                        "Giriş Yap",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell googleSignIn() {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () async {
        /* showDialog(
            context: context,
            builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));

        await authService.signInWithGoogle(context).then((value) {
          if (value != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBarBuilder(),
                ),
                (route) => false);
          } else {
            Navigator.pop(context);
          }
        }); */
      },
      child: Ink(
        padding: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Ink.image(
          image: Image.asset(
            "lib/assets/images/google.png",
          ).image,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
