import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('My Soul', style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.pink[800],
              )),
              SizedBox(height: 8),
              Text('Find real connections in Kenya',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])
              ),
              SizedBox(height: 48),

              if (!_codeSent)...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+254712345678',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.pink,
                  ),
                  child: _loading
                   ? CircularProgressIndicator(color: Colors.white)
                    : Text('Send OTP', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],

              if (_codeSent)...[
                Text('Enter the 6-digit code sent to',
                  style: TextStyle(color: Colors.grey[700])
                ),
                Text(_phoneController.text,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'OTP Code',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.pink,
                  ),
                  child: _loading
                   ? CircularProgressIndicator(color: Colors.white)
                    : Text('Verify', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => setState(() => _codeSent = false),
                  child: Text('Change number'),
                ),
              ],

              if (_error.isNotEmpty)...[
                SizedBox(height: 16),
                Text(_error, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _sendOTP() async {
    setState(() { _loading = true; _error = ''; });
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.sendOTP(
      phoneNumber: _phoneController.text.trim(),
      codeSent: (verificationId) {
        setState(() { _codeSent = true; _loading = false; });
      },
      onError: (error) {
        setState(() { _error = error; _loading = false; });
      },
    );
  }

  void _verifyOTP() async {
    setState(() { _loading = true; _error = ''; });
    final authService = Provider.of<AuthService>(context, listen: false);

    bool success = await authService.verifyOTP(_otpController.text.trim());
    if (!success) {
      setState(() { _error = 'Invalid code. Try again.'; _loading = false; });
    }
  }
}
