import 'package:flutter/foundation.dart';

class CreditCardModel {
  CreditCardModel({
    @required this.brand,
    @required this.cardHolderName,
    @required this.cardNumber,
    @required this.cvvCode,
    @required this.expiryDate,
    this.isCvvFocused,
  });
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String brand = '';
  String cvvCode = '';
  bool isCvvFocused = false;
}
