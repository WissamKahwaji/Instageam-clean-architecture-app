import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clean_arch/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clean_arch/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clean_arch/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_clean_arch/features/presentation/pages/main_screen/main_screen.dart';

import '../../../../consts.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool _isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast('Invalid Email or Password');
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                return MainScreen(uid: authState.uid);
              } else {
                return _bodyWidget();
              }
            });
          }
          return _bodyWidget();
        },
      ),
    );
  }

  _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 90),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
              ),
            ),
            sizeVer(15),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: Image.asset("assets/profile_default.png"),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: blueColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizeVer(30),
            FormContainerWidget(
              controller: _userNameController,
              hintText: "Username",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _bioController,
              hintText: "Bio",
            ),
            sizeVer(15),
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign Up",
              onTapListener: () {
                _signUpUser(context);
              },
            ),
            sizeVer(10),
            _isSigningUp == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'please Wait',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      sizeHor(10),
                      const CircularProgressIndicator(),
                    ],
                  )
                : Container(),
            const Divider(
              color: secondaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConst.signInPage, (route) => false);
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUpUser(BuildContext context) {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
            email: _emailController.text,
            password: _passwordController.text,
            bio: _bioController.text,
            username: _userNameController.text,
            totalPosts: 0,
            totalFollowers: 0,
            totalFollowing: 0,
            followers: const [],
            following: const [],
            name: "",
            profileUrl: "",
            website: "",
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _userNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      _isSigningUp = false;
    });
  }
}
