import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../bloc/authbloc/auth_bloc.dart';
import '../utils/imagepick.dart';

class MaleFemale extends StatefulWidget {
  const MaleFemale({Key? key}) : super(key: key);

  @override
  State<MaleFemale> createState() => _MaleFemaleState();
}

class _MaleFemaleState extends State<MaleFemale> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit an App?'),
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple)),
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: const Text('No'),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple)),
              onPressed: () => SystemNavigator.pop(),
              //return true when click on "Yes"
              child: const Text('Yes'),
            ),
          ],
        ),
      ) ??
          false;
    }
    return WillPopScope(
      onWillPop: showExitPopup ,
      child: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 30),
                          const Text(
                            "What's Your Gender ?",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height*0.2,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      selectedGender = 'Women';
                                    });

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == 'Women'
                                        ? Colors.purple[900]
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:  selectedGender == 'Women'
                                            ? Colors.purple[100]
                                            : Colors.purple,
                                        radius: 40,
                                        child: Icon(Icons.female,color:  selectedGender == 'Women'
                                            ? Colors.purple
                                            : Colors.purple.shade50,),
                                      ),
                                      Text(
                                        'Women',
                                        style: TextStyle(
                                          color: selectedGender == 'Women'
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height*0.2,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      selectedGender = 'Male';
                                    });
                                    // Save selected gender to SharedPreferences
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == 'Male'
                                        ? Colors.purple[900]
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                       CircleAvatar(
                                        backgroundColor:  selectedGender == 'Male'
                                            ? Colors.purple[100]
                                            : Colors.purple,
                                        radius: 40,
                                        child: Icon(Icons.male,color:  selectedGender == 'Male'
                                            ? Colors.purple
                                            : Colors.purple.shade50,),
                                      ),
                                      Text(
                                        'Male',
                                        style: TextStyle(
                                          color: selectedGender == 'Male'
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],),



                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (selectedGender == null) {
                                Get.snackbar("Gender not Selected", "Please select your Gender!");
                                return;
                              }
                              BlocProvider.of<AuthBloc>(context)
                                  .add(SaveGender(gender: selectedGender!));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ImageSelection(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration:  BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: const [
                                      0.1,
                                      0.4,
                                      0.6,
                                      0.9,
                                    ],
                                    colors: [
                                      Colors.purple.shade600,
                                      Colors.purple.shade300,
                                      Colors.purple.shade200,
                                      Colors.purple.shade700,
                                    ],
                                  )),
                              child: const Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}

//===========================================================================================================

class OtherOption extends StatefulWidget {
  const OtherOption({Key? key}) : super(key: key);

  @override
  _OtherOptionState createState() => _OtherOptionState();
}

class _OtherOptionState extends State<OtherOption> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _isSelected,
            onChanged: (bool? value) {
              setState(() {
                _isSelected = value!;
              });
            },
            activeColor: Colors.pink,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: TextFormField(
            controller: _textEditingController,
            enabled: _isSelected,
            decoration: const InputDecoration(
              hintText: 'Others',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
