import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // final size = MediaQuery.of(context).size; //!!Para la Altura que comienza el CardContainer()

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // SizedBox(height: size.height * 0.3), //!!Para la Altura que comienza el CardContainer()
              const SizedBox(height: 250),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30,),

                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                    

                  ],
                ),
              ),

              const SizedBox(height: 50,),
              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 50,),
              
            ],
          ),
        )
      ),
    );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'richi@gmail.com',
                labelText: 'Correo Electronico',
                prefixIcon: Icons.alternate_email_outlined
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no es válido';
                
              },
            ),

            const SizedBox(height: 30,),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress, //!! no es necesario seguro
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contaseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {

                return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña no es válida';
                
              },
            ),

            const SizedBox(height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,

              //?? SIN CircularProgressIndicator() --------------------↓↓↓↓
              child: Container(padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                child: Text(
                  loginForm.isLoading
                    ? 'Espere'
                    : 'Ingresar',
                  style: TextStyle(color: Colors.white)
                  )
              ),
              //?? ↑↑↑↑------------------------------------------------↑↑↑↑

              //?? SOLO CircularProgressIndicator() --------------------↓↓↓↓(cambiar "disabledColor" a "disabledColor: Colors.deepPurple")
              // child:   Container(padding: const EdgeInsets.symmetric(vertical: 15,), width: 190,
              //   child:loginForm.isLoading
              //     ? Center(child: SizedBox(child: CircularProgressIndicator(color: Colors.white,), height: 21, width: 21,))
              //     : Center(child: Text( 'Ingresar', style: TextStyle(color: Colors.white, fontSize: 18)),
              //   ),
              // ),
              //?? ↑↑↑↑------------------------------------------------↑↑↑↑

              //?? CON CircularProgressIndicator() --------------------↓↓↓↓
              // child: Container(padding: EdgeInsets.symmetric(vertical: 15), width: 180,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: loginForm.isLoading ? [
              //       SizedBox(width: 17),
              //       const Text('Espere',  style: TextStyle(color: Colors.white)),
              //       SizedBox(width: 10),
              //       SizedBox(child: CircularProgressIndicator(strokeWidth: 2), height: 15, width: 15,),
              //     ] : [
              //       const Text('Ingresar',  style: TextStyle(color: Colors.white)),
              //     ],
              //   )
              // ),
              //?? ↑↑↑↑------------------------------------------------↑↑↑↑
              
              onPressed: loginForm.isLoading ? null : () async {

                FocusScope.of(context).unfocus();

                if( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(seconds: 2));

                //TODO: Validar si el login es correcto
                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home');
              },

            )
          ],
        )
      ),
    );
  }
}