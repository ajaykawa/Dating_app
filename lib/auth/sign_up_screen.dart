import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../bloc/authbloc/auth_bloc.dart';
import '../const.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController phone = TextEditingController();
  CountryCode? _selectedCountryCode;
  bool isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          print('state ------$state');
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   SizedBox(height: 40.h),
                   Text('Find Your Soulmate',
                      style: TextStyle(
                          fontSize: 34.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(
                    'Meet the right person',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Lottie.asset(
                    'assets/lottie/couples.json',
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.46.h,
                    width: MediaQuery.of(context).size.width.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'Enter Your Number',
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff301934)),
                          ),
                          TextFormField(
                            // maxLength: 15,
                            validator: (value) {
                              if (value!.length < 4) {
                                return 'Input the valid details!';
                              } else {
                                return null;
                              }
                            },
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d+]'))
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle:  TextStyle(fontSize: 16.sp),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      width: 4,
                                      color: Color(0xff301934))),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(
                                    color: Colors.pink,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                              prefixIcon: CountryCodePicker(
                                onChanged: (code) {
                                  setState(() {
                                    _selectedCountryCode = code;
                                  });
                                  print(">>>>>>>>$_selectedCountryCode");
                                },
                                initialSelection: 'IN',
                                favorite: const ['+91', 'IN'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                showDropDownButton: false,
                              ),
                              // Add minLength and maxLength properties here
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              const Text('I agree to the '),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  final FormState? form = _formKey.currentState;
                                  if (form!.validate() && isChecked) {
                                    Object countryCode = _selectedCountryCode ?? '+91';

                                    BlocProvider.of<AuthBloc>(context).add(
                                      SignUpUsingMobileNumber(
                                        phoneNumber: '$countryCode${phone.text}',
                                        countyCode: countryCode.toString(),
                                      ),
                                    );
                                  }else{
                                    errorSnackbar("Agree the Terms and Condition ");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.purple,
                                  backgroundColor: Colors.purple.shade100,
                                  disabledForegroundColor:
                                      Colors.purple,
                                  disabledBackgroundColor:
                                      Colors.purple,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child:  Text(
                                  state is AuthLoading
                                      ? 'Loading...'
                                      : 'Sign up',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
