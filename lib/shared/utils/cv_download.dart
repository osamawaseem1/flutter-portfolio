// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../../core/constants/app_constants.dart';

void downloadCv() {
  html.AnchorElement(href: AppConstants.cvUrl)
    ..setAttribute('download', 'Osama Soliman - Flutter Developer.pdf')
    ..click();
}
