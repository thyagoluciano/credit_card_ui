import 'credit_card_icons_const.dart';

enum CreditCardType {
  visa,
  amex,
  discover,
  mastercard,
  dinersclub,
  jcb,
  unionpay,
  maestro,
  elo,
  mir,
  hiper,
  hipercard,
  unknown,
}

extension BrandMask on CreditCardType {
  String get mask {
    switch (this) {
      case CreditCardType.amex:
        return '#### ###### #####';
        break;
      case CreditCardType.dinersclub:
        return '#### ###### ####';
        break;
      case CreditCardType.discover:
      case CreditCardType.elo:
      case CreditCardType.hiper:
      case CreditCardType.hipercard:
      case CreditCardType.jcb:
      case CreditCardType.maestro:
      case CreditCardType.mastercard:
      case CreditCardType.mir:
      case CreditCardType.unionpay:
      case CreditCardType.unknown:
        return '#### #### #### ####';
        break;
      default:
        return '#### #### #### ####';
        break;
    }
  }
}

extension BrandImage on CreditCardType {
  String get code {
    switch (this) {
      case CreditCardType.visa:
        return VISA;
        break;
      case CreditCardType.amex:
        return AMEX;
        break;
      case CreditCardType.discover:
        return DISCOVER;
        break;
      case CreditCardType.mastercard:
        return MASTERCARD;
        break;
      case CreditCardType.dinersclub:
        return DINERSCLUB;
        break;
      case CreditCardType.jcb:
        return JCB;
        break;
      case CreditCardType.unionpay:
        return UNIONPAY;
        break;
      case CreditCardType.maestro:
        return MAESTRO;
        break;
      case CreditCardType.elo:
        return ELO;
        break;
      case CreditCardType.mir:
        return MIR;
        break;
      case CreditCardType.hiper:
        return HIPER;
        break;
      case CreditCardType.hipercard:
        return HIPERCARD;
        break;
      default:
        return UNKNOWN;
        break;
    }
  }
}
