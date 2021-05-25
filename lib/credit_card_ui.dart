library credit_card_ui;

import 'dart:math';

import 'package:credit_card_ui/credit_card_brand.dart';
import 'package:credit_card_ui/credit_card_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'animation_card.dart';
import 'credit_card_icons_const.dart';
import 'formatter.dart';

class CreditCardUi extends StatefulWidget {
  final Color bgColor;
  final Color brandBgColor;
  final bool isGradient;
  final Gradient gradient;
  final TextStyle cardNumberFontStyle;
  final bool showBackView;
  final double height;
  final double width;
  final Duration animationDuration;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool obscureCardNumber;
  final bool obscureCardCvv;

  CreditCardUi({
    @required this.cardNumber,
    @required this.expiryDate,
    @required this.cardHolderName,
    this.obscureCardNumber = false,
    this.obscureCardCvv = false,
    this.bgColor = Colors.blueAccent,
    this.brandBgColor = Colors.white,
    this.isGradient = true,
    this.gradient = const LinearGradient(
      colors: [
        const Color(0xff0236EC),
        const Color(0xff0532D1),
        const Color(0xff335CEB),
        const Color(0xff022DC4),
        const Color(0xff011B76),
      ],
      begin: const FractionalOffset(0.0, -1.4),
      end: const FractionalOffset(1.4, 0.0),
    ),
    this.cardNumberFontStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontFamily: "Helvetica",
    ),
    this.showBackView = false,
    this.cvvCode = '',
    this.width = 330,
    this.height = 190,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _CreditCardUiState createState() => _CreditCardUiState();
}

class _CreditCardUiState extends State<CreditCardUi>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  int randomColor = 0;
  bool isAmex = false;

  @override
  void initState() {
    var rng = new Random().nextInt(2);
    setState(() {
      randomColor = rng;
    });

    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _frontRotation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);

    _backRotation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String getBrand(String creditCardNumber) {
    String brand;
    if (creditCardNumber != null && creditCardNumber.isNotEmpty) {
      brand = detectCCType(creditCardNumber).code;
    }

    return brand ?? brand;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (widget.showBackView) {
      controller.forward();
    } else {
      controller.reverse();
    }

    return Stack(
      children: <Widget>[
        AnimationCard(
          animation: _frontRotation,
          child: buildFrontContainer(width, height, context, orientation),
        ),
        AnimationCard(
          animation: _backRotation,
          child: buildBackContainer(width, height, context, orientation),
        ),
      ],
    );
  }

  Widget buildFrontContainer(
    double width,
    double height,
    BuildContext context,
    Orientation orientation,
  ) {
    String number = widget.obscureCardNumber
        ? widget.cardNumber.cardNumberObscure()
        : widget.cardNumber;

    String brand = getBrand(widget.cardNumber);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: !widget.isGradient ? widget.bgColor : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  width: 50,
                  child: brand == null ? Container() : SvgPicture.asset(brand),
                  decoration: BoxDecoration(
                    color: brand == null
                        ? Colors.transparent
                        : widget.brandBgColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 50,
                  child: Image.asset(CHIP),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    widget.cardNumber.isEmpty
                        ? '0000 0000 0000 0000'
                        : number.cardFormatter(),
                    style: widget.cardNumberFontStyle,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.cardHolderName.isEmpty
                          ? 'card holder'.toUpperCase()
                          : widget.cardHolderName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "VALID \nTHRU",
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      widget.expiryDate.isEmpty ? '00/00' : widget.expiryDate,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackContainer(
    double width,
    double height,
    BuildContext context,
    Orientation orientation,
  ) {
    final String cvv = widget.cvvCode;
    String brand = getBrand(widget.cardNumber);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: !widget.isGradient ? widget.bgColor : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            height: 40,
            color: Colors.black87,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    height: 40,
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 30,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        cvv,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: brand == null
                        ? Colors.transparent
                        : widget.brandBgColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: brand == null ? Container() : SvgPicture.asset(brand),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
