import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'credit_card_brand.dart';
import 'credit_card_type.dart';

var controller = MaskTextInputFormatter(
  mask: '#### #### #### ####',
  filter: {"#": RegExp(r'[0-9]')},
);

extension StringExtensions on String {
  String cardFormatter() {
    String mask = detectCCType(this).mask;
    controller.clear();
    controller.updateMask(mask: mask, filter: {"#": RegExp(r'[0-9]')});
    return controller.maskText(this);
  }

  // String cardFormatter() {
  //   return this.replaceAllMapped(RegExp(r".{4}"), (match) {
  //     return '${match.group(0)} ';
  //   });
  // }

  String cardNumberObscure() {
    return this.replaceAll(RegExp(r'(?<=.{4})\d(?=.{0})'), '*');
  }
}
