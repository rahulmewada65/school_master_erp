import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/dimens.dart';
import '../../generated/l10n.dart';
import '../../theme/theme_extensions/app_color_scheme.dart';
import '../widgets/card_elements.dart';
import '../widgets/hover_container.dart';
import '../widgets/portal_master_layout/portal_master_layout.dart';
import '../widgets/text_with_copy_button.dart';
import '../widgets/url_new_tab_launcher.dart';

class TextScreen extends StatelessWidget {
  const TextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final textTheme = themeData.textTheme;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
           'FEES STRUCTURE',
            style: themeData.textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'School Fees ',
                  ),
                  CardBody(
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: kDefaultPadding * 2.0,
                      runSpacing: kDefaultPadding * 2.0,
                      children: [
                        // _textEmphasisItem(context, 'Text to emphasize primary.', appColorScheme.primary),
                        // _textEmphasisItem(context, 'Text to emphasize secondary.', appColorScheme.secondary),
                        // _textEmphasisItem(context, 'Text to emphasize error.', appColorScheme.error),
                        // _textEmphasisItem(context, 'Text to emphasize success.', appColorScheme.success),
                        // _textEmphasisItem(context, 'Text to emphasize info.', appColorScheme.info),
                        // _textEmphasisItem(context, 'Text to emphasize warning.', appColorScheme.warning),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: lang.typography,
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: kTextPadding),
                          child: Text(
                            lang.textTheme,
                            style: themeData.textTheme.subtitle1,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: kDefaultPadding),
                        //   child: TextWithCopyButton(
                        //     textWidget: Text(
                        //       'Theme.of(context).textTheme',
                        //       style: GoogleFonts.sourceCodePro(
                        //         fontSize: 12.0,
                        //       ),
                        //     ),
                        //     textToCopy: 'Theme.of(context).textTheme',
                        //     copyIconSize: 13.0,
                        //   ),
                        // ),
                        // _typographyItem(context, 'bodyLarge', textTheme.bodyLarge!, true),
                        // _typographyItem(context, 'bodyMedium', textTheme.bodyMedium!, true),
                        // _typographyItem(context, 'bodySmall', textTheme.bodySmall!, true),
                        // _typographyItem(context, 'bodyText1', textTheme.bodyText1!, true),
                        // _typographyItem(context, 'bodyText2', textTheme.bodyText2!, true),
                        // _typographyItem(context, 'button', textTheme.button!, true),
                        // _typographyItem(context, 'caption', textTheme.caption!, true),
                        // _typographyItem(context, 'displayLarge', textTheme.displayLarge!, true),
                        // _typographyItem(context, 'displayMedium', textTheme.displayMedium!, true),
                        // _typographyItem(context, 'displaySmall', textTheme.displaySmall!, true),
                        // _typographyItem(context, 'headline1', textTheme.headline1!, true),
                        // _typographyItem(context, 'headline2', textTheme.headline2!, true),
                        // _typographyItem(context, 'headline3', textTheme.headline3!, true),
                        // _typographyItem(context, 'headline4', textTheme.headline4!, true),
                        // _typographyItem(context, 'headline5', textTheme.headline5!, true),
                        // _typographyItem(context, 'headline6', textTheme.headline6!, true),
                        // _typographyItem(context, 'headlineLarge', textTheme.headlineLarge!, true),
                        // _typographyItem(context, 'headlineMedium', textTheme.headlineMedium!, true),
                        // _typographyItem(context, 'headlineSmall', textTheme.headlineSmall!, true),
                        // _typographyItem(context, 'labelLarge', textTheme.labelLarge!, true),
                        // _typographyItem(context, 'labelMedium', textTheme.labelMedium!, true),
                        // _typographyItem(context, 'labelSmall', textTheme.labelSmall!, true),
                        // _typographyItem(context, 'overline', textTheme.overline!, true),
                        // _typographyItem(context, 'subtitle1', textTheme.subtitle1!, true),
                        // _typographyItem(context, 'subtitle2', textTheme.subtitle2!, true),
                        // _typographyItem(context, 'titleLarge', textTheme.titleLarge!, true),
                        // _typographyItem(context, 'titleMedium', textTheme.titleMedium!, true),
                        // _typographyItem(context, 'titleSmall', textTheme.titleSmall!, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'Bus Fees',
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: kTextPadding),
                        //   child: UrlNewTabLauncher(
                        //     displayText: 'google_fonts - pub.dev',
                        //     url: 'https://pub.dev/packages/google_fonts',
                        //     fontSize: 13.0,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                        //   child: UrlNewTabLauncher(
                        //     displayText: 'https://fonts.google.com/',
                        //     url: 'https://fonts.google.com/',
                        //     fontSize: 13.0,
                        //   ),
                        // ),
                        // _googleFontItem(context, 'Roboto', GoogleFonts.roboto(), true),
                        // _googleFontItem(context, 'Gentium Basic', GoogleFonts.gentiumBasic(), true),
                        // _googleFontItem(context, 'Josefin Sans', GoogleFonts.josefinSans(), true),
                        // _googleFontItem(context, 'Oswald', GoogleFonts.oswald(), true),
                        // _googleFontItem(context, 'Fascinate', GoogleFonts.fascinate(), false),
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

  Widget _textEmphasisItem(BuildContext context, String text, Color color) {
    return HoverContainer(
      hoverColor: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: 330.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              child: Text(
                '(Bold) $text',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '(Italic) $text',
              style: TextStyle(
                color: color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typographyItem(BuildContext context, String text, TextStyle textStyle, bool withBottomPadding) {
    final lang = Lang.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: (withBottomPadding ? kDefaultPadding * 1.5 : 0.0)),
      child: HoverContainer(
        hoverColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
              child: TextWithCopyButton(
                textWidget: Text(
                  text,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 12.0,
                  ),
                ),
                textToCopy: text,
                copyIconSize: 13.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kTextPadding),
              child: Text(
                lang.loremIpsum,
                style: textStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kTextPadding),
              child: Text(
                '(Bold) ${lang.loremIpsum}',
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '(Italic) ${lang.loremIpsum}',
              style: textStyle.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleFontItem(BuildContext context, String text, TextStyle textStyle, bool withBottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: (withBottomPadding ? kDefaultPadding : 0.0)),
      child: HoverContainer(
        hoverColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
              child: TextWithCopyButton(
                textWidget: Text(
                  text,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 12.0,
                  ),
                ),
                textToCopy: text,
                copyIconSize: 13.0,
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              style: textStyle.copyWith(
                fontSize: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
