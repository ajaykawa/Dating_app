import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
    }
  }
  RangeValues _currentRangeValues = const RangeValues(20, 60);
  int distance = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Discovery Settings',
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {

                Navigator.pop(context);
              },
              child:  Text(
                'Done',
                style: TextStyle(color: Colors.grey, fontSize: 18.sp),
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Text(
                  'Distance Preference',
                  style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                ),
                Text(
                  '${distance}km',
                  style:  TextStyle(
                    fontSize: 20.0.sp,
                  ),
                ),
              ],
            ),
            Slider(
              label: "Distance Preference",
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
              divisions: 12,
              value: distance.toDouble(),
              onChanged: (value) {
                setState(() {
                  distance = value.toInt();
                });
              },
              min: 5,
              max: 100,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Text('Only Show People in this range',style: TextStyle(color: Colors.grey,fontSize: 18.sp),),
                Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.red,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    )
                ),

              ],
            ),
            const Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Age Preference',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  '$_currentRangeValues',
                  style:  TextStyle(
                    fontSize: 18.0.sp,color: Colors.grey
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: _currentRangeValues,
              inactiveColor: Colors.grey,
              activeColor: Colors.red,
              min: 0,
              max: 100,
              divisions: 50,
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Text('Only Show People in this range',style: TextStyle(color: Colors.grey,fontSize: 18.sp),),
                Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.red,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    )
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
