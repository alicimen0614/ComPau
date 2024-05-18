import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:community_social_media/widgets/elevated_button_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../bottom_nav_bar_builder.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_form_field.dart';

enum FormStatus { signIn, register, reset }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirestoreService _firestoreService = FirestoreService();
  final signInFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController registerPasswordConfirmController =
      TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  FormStatus formStatus = FormStatus.signIn;
  bool isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            padding: context.paddingAllDefault,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSpacer(context.dynamicHeight(.06)),
                SizedBox(
                  height: context.dynamicHeight(.1),
                  child: Text(
                    formStatus == FormStatus.signIn
                        ? "Merhaba!"
                        : formStatus == FormStatus.register
                            ? "Hesabını oluştur"
                            : "Şifremi unuttum",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                formStatus == FormStatus.signIn
                    ? SizedBox(
                        height: context.dynamicHeight(.07),
                        child: Text(
                          "Giriş Yap",
                          style: context.textTheme.displaySmall,
                        ),
                      )
                    : const SizedBox.shrink(),
                formStatus == FormStatus.register
                    ? registerForm()
                    : formStatus == FormStatus.signIn
                        ? signInForm()
                        : resetForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form signInForm() {
    return Form(
      key: signInFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _viewTextFormfield(
              topRadius: 25,
              bottomRadius: 10,
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
            _viewTextFormfield(
              topRadius: 10,
              bottomRadius: 25,
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
            Align(
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
            SizedBox(
              height: context.dynamicHeight(.07),
              child: CustomElevatedButton(
                paddingVertical: context.dynamicHeight(.01),
                paddingHorizontal: context.dynamicWidth(.07),
                btnTitle: 'Giriş Yap',
                onPressed: () async {
                  if (signInFormKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ));
                    await authService
                        .signInWithEmailAndPassword(signInEmailController.text,
                            signInPasswordController.text, context)
                        .then((value) {
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
                    });
                  }
                },
                borderRadius: 50,
              ),
            ),
            _buildSpacer(context.dynamicHeight(.05)),
            SizedBox(
              width: context.width,
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
            _buildSpacer(context.dynamicHeight(.05)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Üye değil misin?",
                  style: context.textTheme.bodyLarge,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        formStatus = FormStatus.register;
                      });
                    },
                    child: Text(
                      "Üye Ol",
                      style: context.textTheme.bodyLarge,
                    )),
              ],
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            _viewTextFormfield(
              topRadius: 25,
              bottomRadius: 10,
              child: CustomTextFormField(
                validator: (value) {
                  return null;
                },
                textEditingController: usernameController,
                autoCorrect: true,
                textInputType: TextInputType.emailAddress,
                prefixIconData: Icons.account_circle,
                label: 'İsim-Soyism',
              ),
            ),
            _viewTextFormfield(
              topRadius: 10,
              bottomRadius: 10,
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
                prefixIconData: Icons.mail,
                label: 'Email',
              ),
            ),
            _viewTextFormfield(
              topRadius: 10,
              bottomRadius: 10,
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
            _viewTextFormfield(
              topRadius: 10,
              bottomRadius: 25,
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
            _buildSpacer(context.dynamicHeight(.03)),
            CustomElevatedButton(
              btnTitle: 'Kayıt ol',
              onPressed: () async {
                if (registerFormKey.currentState!.validate()) {
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
                      .then((value) async {
                    if (value != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBarBuilder(),
                          ),
                          (route) => false);
                      await _firestoreService
                          .createUser(usernameController.text);
                    } else {
                      Navigator.pop(context);
                    }
                  });
                }
              },
              borderRadius: 50,
            ),
            _buildSpacer(context.dynamicHeight(.04)),
            SizedBox(
              width: context.width,
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
            _buildSpacer(context.dynamicHeight(.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Zaten üye misin?",
                  style: context.textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      formStatus = FormStatus.signIn;
                    });
                  },
                  child: Text(
                    "Giriş Yap",
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              ],
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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            _buildSpacer(context.dynamicHeight(.05)),
            SizedBox(
              height: context.dynamicHeight(.12),
              child: _viewTextFormfield(
                topRadius: 25,
                bottomRadius: 25,
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
            ),
            _buildSpacer(context.dynamicHeight(.10)),
            SizedBox(
              height: context.dynamicHeight(.07),
              child: CustomElevatedButton(
                btnTitle: 'Gönder',
                onPressed: () {},
                borderRadius: 50,
              ),
            ),
            _buildSpacer(context.dynamicHeight(.1)),
            SizedBox(
              width: context.width,
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
            _buildSpacer(context.dynamicHeight(.12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Şifreni hatırladın mı?",
                  style: context.textTheme.bodyLarge,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        formStatus = FormStatus.signIn;
                      });
                    },
                    child: Text(
                      "Giriş Yap",
                      style: context.textTheme.bodyLarge,
                    )),
              ],
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
        showDialog(
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
        });
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

  Widget _buildSpacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget _viewTextFormfield({
    required double topRadius,
    required double bottomRadius,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius),
          bottom: Radius.circular(bottomRadius),
        ),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
