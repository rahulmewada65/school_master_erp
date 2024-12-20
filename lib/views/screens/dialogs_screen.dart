import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../constants/dimens.dart';
import '../../generated/l10n.dart';
import '../../theme/theme_extensions/app_button_theme.dart';
import '../widgets/card_elements.dart';
import '../widgets/portal_master_layout/portal_master_layout.dart';
import '../widgets/url_new_tab_launcher.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({Key? key}) : super(key: key);

  void _showDialog(BuildContext context, DialogType dialogType) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: 'Dialog Title',
      desc: 'Dialog body...',
      width: kDialogWidth,
      btnOkOnPress: () {},
      btnCancelOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appButtonTheme = themeData.extension<AppButtonTheme>()!;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.dialogs(2),
            style: themeData.textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: lang.dialogs(2),
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                          child: UrlNewTabLauncher(
                            displayText: 'awesome_dialog - pub.dev',
                            url: 'https://pub.dev/packages/awesome_dialog',
                            fontSize: 13.0,
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: kDefaultPadding * 2.0,
                          runSpacing: kDefaultPadding * 2.0,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _showDialog(context, DialogType.INFO),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Info'),
                            ),
                            ElevatedButton(
                              onPressed: () => _showDialog(
                                  context, DialogType.INFO_REVERSED),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Info Reversed'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDialog(context, DialogType.WARNING),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Warning'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDialog(context, DialogType.ERROR),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Error'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDialog(context, DialogType.SUCCES),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Success'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _showDialog(context, DialogType.QUESTION),
                              style: appButtonTheme.primaryElevated,
                              child: const Text('Question'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
