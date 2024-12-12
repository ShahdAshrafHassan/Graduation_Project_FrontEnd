import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_up/url.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SignUp Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>(); // Form key to validate form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isNotValidate = false ;
      

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Function to toggle password visibility
  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If form is valid, perform sign-up logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing up...')),
      );
      registerUser() ;
      // You can send this data to the server or perform further actions
    }
  }

  void registerUser() async{
    if(_emailController.text.isNotEmpty&&_passwordController.text.isNotEmpty){

      var regBody ={
        "email":_emailController.text ,
        "password" : _passwordController.text
      };
      var response = await http.post(Uri.parse(registration) , 
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(regBody)
      );

      print(response) ;

    }else{
      setState(() {
        _isNotValidate = true;
      });
      registerUser() ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
  automaticallyImplyLeading: false,  // Prevents the default back button
  
  elevation: 0,
  toolbarHeight: 60,  // Adjust height of the AppBar for better space
  leading: Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton(),
        SizedBox(height: 4),  // Space between the back button and text
       
      ],
    ),
  ),
),





      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
          'Create your account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 35,  // Adjust font size to fit the available space
          ),
        ),
                // Email Field
                SizedBox(height: 35,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                  
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 45),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 45),
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleConfirmPassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 55),
                // Sign Up Button
Container(
  alignment: Alignment.center, // Aligning the container to center
  child: ElevatedButton(
    onPressed: _submitForm,
    child: Text('Sign Up'),
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(Size(327, 50)), // Correctly specifying minimumSize
      padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Snug padding
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.blue, // Button color
      ),
    ),
  ),
), SizedBox(height:20),
Center(
  child: Text(
    'Sign up with ',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontSize: 15,  // Adjust font size to fit the available space
    ),
  ),
),
 SizedBox(height:30),




                SizedBox(height:170),
                // Already have an account text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to login page
                        // For now, this will just show a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Redirect to login page')),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
