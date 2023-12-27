import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class AuthdPassChangeView extends StatefulWidget {
  const AuthdPassChangeView({super.key});

  @override
  State<AuthdPassChangeView> createState() => _AuthdPassChangeViewState();
}

class _AuthdPassChangeViewState extends State<AuthdPassChangeView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _pass1 = TextEditingController(); 
    final _pass2 = TextEditingController(); 

    return AppScaffold(
      title: Text(Tprovider.get('send_transfer')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    Tprovider.get('drawer_pass'),
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: Tprovider.get('new_pass')),
                    obscureText: true,
                    validator: (value) => RegexMatchers.matchPassword(
                        value,
                        Tprovider.get('invalid_form'),
                        Tprovider.get('password_min8ch'),
                        8,
                        Tprovider.get('field_cannotempty')),
                    controller: _pass1,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: Tprovider.get('confirm_new_pass')),
                    obscureText: true,
                    validator: (value) {
                      if (value != _pass1.text)
                        return Tprovider.get('passwords_need_equal');
                      return null;
                    },
                    controller: _pass2,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      WaitingDialog.show(context);
                     var res = await ApiService.instance.changePassword(_pass1.text);
                      Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                      if(res) {
                       SuccessDialog.show(NavigationContext.mainNavKey.currentContext!, Tprovider.get('password_ch_suc'), onOk: () async {
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                       });
                     }else {
                       ErrorDialog.show(NavigationContext.mainNavKey.currentContext!, Tprovider.get('password_ch_fail'), onOk: () async {
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                       });
                     }
                    },
                    child: Text(Tprovider.get('drawer_pass')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
