import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'package:furniscapemobileapp/screens/home_screen.dart';
import 'package:furniscapemobileapp/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });


  //   Splitting the fullname into firstname and lastname [backend has fullname and lastname]
  //   final nameParts = fullName.split(' ');
  //   final firstName = nameParts.isNotEmpty ? nameParts.first : '';
  //   final lastName = nameParts.isNotEmpty ? nameParts.sublist(1).join(' ') : '';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      // firstName : firstName,
      // lastName : lastName,
      name : _nameController.text.trim(),
      email : _emailController.text.trim(),
      password : _passwordController.text,
      confirmPassword : _confirmPasswordController.text,
      phone : _phoneController.text.trim(),
      address : _addressController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });
    
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }  else {
      setState(() {
        _errorMessage = 'Registration failed. Please try again.';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              ),
          ),
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
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'REGISTER',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      const SizedBox(height: 16,),

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 16,),

                      _buildTextField(_nameController, 'Full Name'),
                      _buildTextField(_emailController, 'Email', inputType: TextInputType.emailAddress),
                      _buildPasswordField(_passwordController, 'Password'),
                      _buildPasswordField(_confirmPasswordController, 'Confirm Password'),
                      _buildTextField(_phoneController, 'Phone Number'),
                      _buildTextField(_addressController, 'Address'),

                      const SizedBox(height: 20,),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                              'Register',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LoginScreen()) ,
                            );
                          },
                          child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondary,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: theme.colorScheme.onSecondary,
                                    ),
                                  ),
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

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType inputType = TextInputType.text}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter your $label';
            }
            return null;
          },
        ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: controller,
          obscureText: !_passwordVisible,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
              onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Enter $label';
            if (label == 'Confirm Password' && value != _passwordController.text) {
              return 'Passwords do not match';
            }
            if (value.length < 8)
              return 'Minimum 8 characters';
              return null;
          },
        ),
    );
  }

}


