import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/lists_.dart';

class Mycontrol extends GetxController {




  RxList<bool> drinkhabits = List.filled(6, false).obs;
  RxInt selecteddrinkcount = 0.obs;
  RxString selectedDrinkingHabit = ''.obs;
  RxList<String> selectedDrink = <String>[].obs;

  void DrinkingHabits(int index) {
    if (drinkhabits[index] == false) {
      if (selecteddrinkcount.value < 1) {
        drinkhabits[index] = true;
        selecteddrinkcount.value++;
        selectedDrinkingHabit.value = drink[index];
        selectedDrink.add(drink[index]);
      } else {
        // deselect previously selected option
        int prevSelectedIndex = drink.indexOf(selectedDrinkingHabit.value);
        drinkhabits[prevSelectedIndex] = false;
        drinkhabits[index] = true;
        selectedDrinkingHabit.value = drink[index];
        selectedDrink.value = [drink[index]];
      }
    } else {
      drinkhabits[index] = false;
      selecteddrinkcount.value--;
      selectedDrinkingHabit.value = '';
      selectedDrink.remove(drink[index]);
    }
  }

  RxList<bool> smokehabits = List.filled(5, false).obs;
  RxInt selectedsmokescount = 0.obs;
  RxString selectedSmokeHabit = ''.obs;
  RxList<String> selectedSmoke = <String>[].obs;
  void Smokinghabits(int index) {
    if (smokehabits[index] == false) {
      if (selectedsmokescount.value < 1) {
        smokehabits[index] = true;
        selectedsmokescount.value++;
        selectedSmokeHabit.value = smoke[index];
        selectedSmoke.add(smoke[index]);
      } else {
        int prevSelectedIndex = smoke.indexOf(selectedSmokeHabit.value);
        smokehabits[prevSelectedIndex] = false;
        smokehabits[index] = true;
        selectedSmokeHabit.value = smoke[index];
        selectedSmoke.value = [smoke[index]];
      }
    } else {
      smokehabits[index] = false;
      selectedsmokescount.value--;
      selectedSmokeHabit.value = '';
      selectedSmoke.remove(smoke[index]);
    }
  }

  RxList<bool> dietprefer = List.filled(8, false).obs;
  RxInt selecteddietscount = 0.obs;
  RxString selectedDietPreference = ''.obs;
  RxList<String> selectedDietpref = <String>[].obs;

  void DietPref(int index) {
    if (dietprefer[index] == false) {
      if (selecteddietscount.value < 1) {
        dietprefer[index] = true;
        selecteddietscount.value++;
        selectedDietpref.add(diet[index]);
      } else {
        // deselect previously selected pet
        for (int i = 0; i < dietprefer.length; i++) {
          if (i != index) {
            dietprefer[i] = false;
          }
        }
        dietprefer[index] = true;
        selectedDietpref.value = [diet[index]];
      }
    } else {
      dietprefer[index] = false;
      selecteddietscount.value--;
      selectedDietpref.remove(pets[index]);
    }
  }

  String selectedPets = "Dog,Cat..";

  void setSelectedPets(
      RxString petstype,
      ) {
    selectedPets = petstype.value;
  }

  RxList<bool> petslike = List.filled(26, false).obs;
  RxInt selectedpetscount = 0.obs;
  RxList<String> selectedPetsList = <String>[].obs;

  void PetsSelected(int index) {
    if (petslike[index] == false) {
      if (selectedpetscount.value < 1) {
        petslike[index] = true;
        selectedpetscount.value++;
        selectedPetsList.add(pets[index]);
      } else {
        // deselect previously selected pet
        for (int i = 0; i < petslike.length; i++) {
          if (i != index) {
            petslike[i] = false;
          }
        }
        petslike[index] = true;
        selectedPetsList.value = [pets[index]];
      }
    } else {
      petslike[index] = false;
      selectedpetscount.value--;
      selectedPetsList.remove(pets[index]);
    }
  }

  RxString selectedlanguages = "".obs;

  void setSelectedLanguages(RxString languagesselected) {
    selectedlanguages.value = languagesselected.value;
  }

  RxList<bool> languageknow = List.filled(26, false).obs;
  RxInt selectedlanguagecount = 0.obs;

  void languageKnown(int index) {
    if (languageknow[index] == false) {
      if (selectedlanguagecount.value < 5) {
        languageknow[index] = true;
        selectedlanguagecount.value++;
      }
    } else {
      languageknow[index] = false;
      selectedlanguagecount.value--;
    }
  }

  RxString getSelectedLanguages() {
    RxList selectedLanguages = [].obs;
    for (int i = 0; i < languageknow.length; i++) {
      if (languageknow[i]) {
        selectedLanguages.add(languages[i].obs);
      }
    }
    selectedlanguages.value = selectedLanguages.join(', ');
    return selectedlanguages;
  }

  RxList<bool> relationshiptype = List.filled(4, false).obs;
  RxInt selectedtypecount = 0.obs;
  RxString selectedrelationtype = ''.obs;
  RxList<String> selectedtype = <String>[].obs;

  void SetSelectedRelationtype(int index) {
    if (relationshiptype[index] == false) {
      // deselect previously selected option
      int prevSelectedIndex = relationtype.indexOf(selectedrelationtype.value);
      if (prevSelectedIndex != -1) {
        relationshiptype[prevSelectedIndex] = false;
        selectedtypecount.value--;
        selectedtype.remove(selectedrelationtype.value);
      }

      relationshiptype[index] = true;
      selectedtypecount.value++;
      selectedrelationtype.value = relationtype[index];
      selectedtype.add(relationtype[index]);
      print("||||||||||||||||||||||||||||||||||||${relationtype[index]}");
    } else {
      relationshiptype[index] = false;
      selectedtypecount.value--;
      selectedrelationtype.value = '';
      selectedtype.remove(relationtype[index]);
    }
  }

  RxString goals = ''.obs;
  RxString selectedRelationshipGoal = "Looking for".obs;
  IconData? selectedIcon;
  RxList<String> selectedGoal = <String>[].obs;

  RxInt tot = 0.obs;

  void setSelectedValues(String relationshipGoal, IconData icon) {
    selectedRelationshipGoal = relationshipGoal.obs;
    selectedIcon = icon;
  }
}