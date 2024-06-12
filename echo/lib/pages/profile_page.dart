import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth_provider.dart';

import '../services/db_service.dart';

import '../models/contact.dart';

class ProfilePage extends StatelessWidget {
  final double _height;
  final double _width;

  late final AuthProvider _auth; //_auth needs to be marked as late

  ProfilePage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _profilePageUI(),
      ),
    );
  }

  Widget _profilePageUI() {
    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<Contact>(
          stream: _auth.user != null? DBService.instance.getUserData(_auth.user!.uid): Stream.empty(),
          builder: (context, snapshot) {
            var _userData = snapshot.data;
            return snapshot.hasData
                ? Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: _height * 0.50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _userImageWidget(_userData!.image),
                          _userNameWidget(_userData.name),
                          _userEmailWidget(_userData.email),
                          _logoutButton(),
                        ],
                      ),
                    ),
                  )
                : SpinKitWanderingCubes(
                    color: Colors.blue,
                    size: 50.0,
                  );
          },
        );
      },
    );
  }

  Widget _userImageWidget(String _image) {
    double _imageRadius = _height * 0.20;
    return Container(
      height: _imageRadius,
      width: _imageRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_imageRadius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_image),
        ),
      ),
    );
  }

  Widget _userNameWidget(String _userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        _userName,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget _userEmailWidget(String _email) {
    return Container(
      height: _height * 0.03,
      width: _width,
      child: Text(
        _email,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white24, fontSize: 15),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      height: _height * 0.06,
      width: _width * 0.80,
      child: MaterialButton(
        onPressed: () async {
          await AuthProvider.instance.logoutUser(() async {});
        },
        color: Colors.red,
        child: Text(
          "LOGOUT",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}