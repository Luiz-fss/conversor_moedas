import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  String _label;
  String _prfix;
  TextEditingController _controller = TextEditingController();
  Function _funcao;
  TextFieldCustom(
      this._controller,
      this._funcao,
      this._label,
      this._prfix
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: TextStyle(
          color: Colors.amber,
          fontSize: 25.0
      ),
      decoration: InputDecoration(
          labelText: _label,
          border: OutlineInputBorder(),
          prefixText: "$_prfix\$ ",
          labelStyle: TextStyle(
            color: Colors.amber,
          )
      ),
      onChanged: _funcao,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
