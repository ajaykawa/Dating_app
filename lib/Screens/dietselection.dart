import 'package:flutter/material.dart';

import '../const.dart';

class DietSelections extends StatefulWidget {
  const DietSelections({Key? key}) : super(key: key);

  @override
  State<DietSelections> createState() => _DietSelectionsState();
}

class _DietSelectionsState extends State<DietSelections> {
  List<String> interests = [
    'Vegan',
    'Vegetarian',
    'Pescatarian',
    'Kosher',
    'Carnivore',
    'Other',
  ];

  List<bool> selectedInterests = List.filled(15, false);

  void updateSelectedInterests(int index) {
    setState(() {
      if (selectedInterests[index] == false) {
        int count = 0;
        for (int i = 0; i < selectedInterests.length; i++) {
          if (selectedInterests[i] == true) {
            count++;
          }
        }
        if (count < 1) {
          selectedInterests[index] = true;
        }
      } else {
        selectedInterests[index] = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.pink),
                    ),
                    const Spacer(),
                    const Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.pink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 45),
                const Text(
                  'About your Foods',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Select  1 interests and let everyone know what you’re thinking about.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(interests.length, (index) {
                    return InterestSelection(
                      text: interests[index],
                      isSelected: selectedInterests[index],
                      onTap: () {
                        updateSelectedInterests(index);
                      }, Iconn: Icon(Icons.fastfood_rounded),
                    );
                  }),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) {
                    //     return const ProfileScreen();
                    //   },
                    // ));
                    List<String> selected = [];
                    for (int i = 0; i < selectedInterests.length; i++) {
                      if (selectedInterests[i] == true) {
                        selected.add(interests[i]);
                      }
                    }
                    print(selected);
                  },
                  child: const Text('Next'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
