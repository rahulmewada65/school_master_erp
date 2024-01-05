import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app_router.dart';
import '../../constants/dimens.dart';
import '../../generated/l10n.dart';
import '../../providers/user_data_provider.dart';
import '../../services/auth_service.dart';
import '../../theme/theme_extensions/app_button_theme.dart';
import '../../theme/theme_extensions/app_color_scheme.dart';
import '../../utils/app_focus_helper.dart';
import '../widgets/public_master_layout/public_master_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();

  var _isFormLoading = false;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  // IOSOptions _getIOSOptions() => const IOSOptions(
  //   accessibility: IOSAccessibility.first_unlock,
  // );
  Future<void> _doLoginAsync({
    required UserDataProvider userDataProvider,
    required VoidCallback onSuccess,
    required void Function(String message) onError,
  }) async {
    AppFocusHelper.instance.requestUnfocus();
    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();
      setState(() => _isFormLoading = true);
      Future.delayed(const Duration(seconds: 2), () async {
        var res =
            await authService.login(_formData.username, _formData.password);
        print(res!.statusCode);
        if (res!.statusCode != 200) {
          onError.call('Invalid username or password.');
        } else {
          var data = jsonDecode(res.body);
          // print(res.body);
          // print(data['accessToken']);
          await storage.write(
            key: "login", value: res.body,
            aOptions: _getAndroidOptions(), //iOptions: _getIOSOptions()
          );
          await storage.write(
            key: "accessToken", value: data['accessToken'],
            aOptions: _getAndroidOptions(), //iOptions: _getIOSOptions()
          );
          await storage.write(
              key: "username",
              value: data['username'],
              aOptions: _getAndroidOptions()
              //iOptions: _getIOSOptions(),
              );
          await storage.write(
            key: "id", value: data["id"].toString(),
            aOptions: _getAndroidOptions(), //iOptions: _getIOSOptions()
          );
          await storage.write(
              key: "email", value: data['email'], aOptions: _getAndroidOptions()
              //iOptions: _getIOSOptions(),
              );
          await storage.write(
              key: "roles",
              value: data['roles'].toString(),
              aOptions: _getAndroidOptions()
              //iOptions: _getIOSOptions(),
              );
          await storage.write(
              key: "tokenType",
              value: data['tokenType'],
              aOptions: _getAndroidOptions()
              //iOptions: _getIOSOptions(),
              );
          await userDataProvider.setUserDataAsync(
            username: data['username'],
            userProfileImageUrl: 'https://picsum.photos/id/1005/300/300',
          );
          onSuccess.call();
        }
        setState(() => _isFormLoading = false);
      });
    }
  }

  void _onLoginSuccess(BuildContext context) {
    GoRouter.of(context).go(RouteUri.home);
  }

  void _onLoginError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      desc: message,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);

    return PublicMasterLayout(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(
                top: kDefaultPadding * 1.0, bottom: kDefaultPadding * 1.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Image.asset(
                        'assets/app_logo.png',
                        height: 80.0,
                      ),
                    ),
                    Text(
                      lang.appTitle,
                      style: themeData.textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: Text(
                        lang.adminPortalLogin,
                        style: themeData.textTheme.titleMedium,
                      ),
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'username',
                              decoration: InputDecoration(
                                labelText: lang.username,
                                hintText: lang.username,
                                // helperText: '* Demo username: admin',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              onSubmitted: (value) {
                                _formData.username = value ?? '';
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _doLoginAsync(
                                    userDataProvider:
                                        context.read<UserDataProvider>(),
                                    onSuccess: () => _onLoginSuccess(context),
                                    onError: (message) =>
                                        _onLoginError(context, message),
                                  );
                                }
                              },
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.username = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding * 2.0),
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: InputDecoration(
                                labelText: lang.password,
                                hintText: lang.password,
                                // helperText: '* Demo password: admin',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              onSubmitted: (value) {
                                _formData.password = value ?? '';
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _doLoginAsync(
                                    userDataProvider:
                                        context.read<UserDataProvider>(),
                                    onSuccess: () => _onLoginSuccess(context),
                                    onError: (message) =>
                                        _onLoginError(context, message),
                                  );
                                }
                              },
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.password = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData
                                    .extension<AppButtonTheme>()!
                                    .primaryElevated,
                                onPressed: (_isFormLoading
                                    ? null
                                    : () => _doLoginAsync(
                                          userDataProvider:
                                              context.read<UserDataProvider>(),
                                          onSuccess: () =>
                                              _onLoginSuccess(context),
                                          onError: (message) =>
                                              _onLoginError(context, message),
                                        )),
                                child: Text(lang.login),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                            width: double.infinity,
                            child:
                            TextButton(
                              style: themeData
                                  .extension<AppButtonTheme>()!
                                  .secondaryText,
                              onPressed: () =>
                                  GoRouter.of(context).go(RouteUri.register),
                              child: RichText(
                                text: TextSpan(
                                  text: '${lang.dontHaveAnAccount} ',
                                  style: TextStyle(
                                    color: themeData.colorScheme.onSurface,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: lang.registerNow,
                                      style: TextStyle(
                                        color: themeData
                                            .extension<AppColorScheme>()!
                                            .hyperlink,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class FormData {
  String username = '';
  String password = '';
}
