import 'package:flutter/material.dart';
import 'package:school_master_erp/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:school_master_erp/views/widgets/portal_master_layout/sidebar.dart';

import 'app_router.dart';
import 'generated/l10n.dart';

final sidebarMenuConfigs = [
  SidebarMenuConfig(
    uri: RouteUri.dashboard,
    icon: Icons.dashboard_rounded,
    title: (context) => Lang.of(context).dashboard,
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Student",
    // Lang.of(context).uiElements(2)",
    children: [
      // SidebarChildMenuConfig(
      //     uri: RouteUri.student,
      //     icon: Icons.dashboard_rounded,
      //     title: (context) => "Student Profile"
      //     //Lang.of(context).dashboard,
      //     ),
      SidebarChildMenuConfig(
        uri: RouteUri.crud,
        icon: Icons.circle_outlined,
        title: (context) => 'Student List',
      ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Teachers",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.teacher_screen,
          icon: Icons.dashboard_rounded,
          title: (context) => "Teacher List"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Class",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Class List"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Subject",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.subject_screen,
          icon: Icons.dashboard_rounded,
          title: (context) => "Subject List"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Exam",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.exam_screen,
          icon: Icons.dashboard_rounded,
          title: (context) => "Exam List"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
      uri: '',
      icon: Icons.interests_rounded,
      title: (context) => "Fees Structure ",
      // Lang.of(context).uiElements(2)",
      children: [
        SidebarChildMenuConfig(
            uri: RouteUri.feeScreen,
            icon: Icons.circle_outlined,
            title: (context) => "Fees Element List"
            //Lang.of(context).text,
            ),
        SidebarChildMenuConfig(
            uri: RouteUri.structure_screen,
            icon: Icons.circle_outlined,
            title: (context) => "Structure List"
            //Lang.of(context).text,
            ),
        // SidebarChildMenuConfig(
        //     uri: RouteUri.create_structure,
        //     icon: Icons.circle_outlined,
        //     title: (context) => "Create Fees Structure"
        //     //Lang.of(context).text,
        //     ),
      ]),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Buses",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Bus List"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.interests_rounded,
    title: (context) => "Reports",
    // Lang.of(context).uiElements(2)",
    children: [
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Admission Report"
          //Lang.of(context).dashboard,
          ),
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Fee Report"
          //Lang.of(context).dashboard,
          ),
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Bus Report"
          //Lang.of(context).dashboard,
          ),
      SidebarChildMenuConfig(
          uri: RouteUri.classes,
          icon: Icons.dashboard_rounded,
          title: (context) => "Teachers Report"
          //Lang.of(context).dashboard,
          ),
      // SidebarChildMenuConfig(
      //   uri: RouteUri.class_screen,
      //   icon: Icons.circle_outlined,
      //   title: (context) => 'Add New Class ',
      // ),
      // SidebarChildMenuConfig(
      //     uri: RouteUri.form,
      //     icon: Icons.edit_note_rounded,
      //     title: (context) => "Admission"
      //     //Lang.of(context).forms(1),
      //     ),
    ],
  ),
  SidebarMenuConfig(
    uri: '',
    icon: Icons.library_books_rounded,
    title: (context) => Lang.of(context).pages(2),
    children: [
      SidebarChildMenuConfig(
        uri: RouteUri.generalUi,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).generalUi,
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.buttons,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).buttons(2),
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.dialogs,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).dialogs(2),
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.error404,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).error404,
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.colors,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).colors(2),
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.login,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).login,
      ),
      SidebarChildMenuConfig(
        uri: RouteUri.register,
        icon: Icons.circle_outlined,
        title: (context) => Lang.of(context).register,
      ),
    ],
  ),
  // SidebarMenuConfig(
  //   uri: RouteUri.iframe,
  //   icon: Icons.laptop_windows_rounded,
  //   title: (context) => Lang.of(context).iframeDemo,
  // ),
];

const localeMenuConfigs = [
  LocaleMenuConfig(
    languageCode: 'en',
    name: 'English',
  ),
  LocaleMenuConfig(
    languageCode: 'zh',
    scriptCode: 'Hans',
    name: '中文 (简体)',
  ),
  LocaleMenuConfig(
    languageCode: 'zh',
    scriptCode: 'Hant',
    name: '中文 (繁體)',
  ),
];
