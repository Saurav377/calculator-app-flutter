import 'package:flutter/material.dart';

import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  //assigning empty values
  String number1 = "";
  String operand = "";
  String number2 = "";

  //creating widgets
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //number screen
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              //buttons
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  //creating button looks
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
            value,
            style: const TextStyle(fontSize: 20),
          )),
        ),
      ),
    );
  }

  //button check
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    } else if (value == Btn.clr) {
      clearAll();
      return;
    } else if (value == Btn.per) {
      convertToPercentage();
      return;
    } else if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  //main calculation
  void calculate() {
    if (number1.isEmpty) return;
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      default:
        break;
    }
    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  //percentage button
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  //clr button
  void clearAll() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
    });
  }

  //delete button
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  //appending numbers to screen
  void appendValue(String value) {
    //operand check
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    }
    //number1 check
    else if (number1.isEmpty || operand.isEmpty) {
      //dot check
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    }
    //number2 check
    else if (number2.isEmpty || operand.isNotEmpty) {
      //dot check
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  //setting color of different button
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr, Btn.calculate].contains(value)
        ? const Color.fromARGB(255, 120, 120, 120)
        : [Btn.per, Btn.multiply, Btn.add, Btn.divide, Btn.subtract]
                .contains(value)
            ? Color.fromARGB(255, 215, 129, 0)
            : Colors.black87;
  }
}
