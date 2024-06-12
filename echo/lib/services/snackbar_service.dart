import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackBarService {
  late BuildContext _buildContext;

  static final SnackBarService instance = SnackBarService();

  SnackBarService();

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  void showSnackBarError(String message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(_buildContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
