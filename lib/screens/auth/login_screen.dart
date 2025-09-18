import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/screens/main_navigation_screen.dart';
import 'package:provider/provider.dart';

import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'package:furniscapemobileapp/screens/home_screen.dart';

import 'package:furniscapemobileapp/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Controllers used to read user input from the form fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Helps in validating and managing the form
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;  //Toggle password visibility
  bool _isLoading = false;   //shows a loading during login
  String? _errorMessage;   //Stores error message when login fails

  @override

  // Dispose the controllers to free memory [when the widget is removed.]
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validating the form before submitting
  Future<void> _submit() async {
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Calls the login method with trimmed input from the user  [trim will remove the extra spaces at the begining and end of the string]
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    // Hides loading spinner after login attempt
    setState(() {
      _isLoading = false;
    });

    // On success it navigates to HomeScreen, On failure sets error message for dispaly
    if(success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
        //   Background Image full screen
          Positioned.fill(
              child: Image.asset('assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              ),
          ),
        //   Bottom Login container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOGIN',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight:  FontWeight.bold,
                          color: theme.colorScheme.onSecondary,
                      ),
                      ),
                      const SizedBox(height: 24,),

                      // Displays error message if error occured
                      if (_errorMessage != null)
                        Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 16,),

                    //   Email Text Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Enter your Email',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty){
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16,),

                      //   Password Text Field with visibility toggle
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Enter your Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _passwordVisible
                                    ?Icons.visibility
                                    :Icons.visibility_off,
                                color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20,),

                    //   Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            // onPressed: widget.onLoginClicked,
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              backgroundColor:  theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                            'Login',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ),

                      const SizedBox(height: 8,),

                    //   Register Text Button
                      TextButton(
                        // onPressed: widget.onRegisterClicked,
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                      child: RichText(
                          text: TextSpan(
                            text: "Don't have an account?",
                            style:  TextStyle(
                              color: theme.colorScheme.onSecondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: theme.colorScheme.onSecondary,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
