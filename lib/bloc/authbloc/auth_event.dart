part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignUpUsingMobileNumber extends AuthEvent {
  final String phoneNumber;
  final String countyCode;

  SignUpUsingMobileNumber(
      {required this.phoneNumber, required this.countyCode});
}

class OtpVerification extends AuthEvent {
  final String otpsent;
  final String verificationId;

  OtpVerification({
    required this.otpsent,
    required this.verificationId,
  });
}

class SaveUserDetails extends AuthEvent {
  final String user;


  SaveUserDetails({
    required this.user,

  });
}

class SaveGender extends AuthEvent {
  final String gender;

  SaveGender({
    required this.gender,
  });
}

class SaveInterests extends AuthEvent{
  final String allinterests;

  SaveInterests({
   required this.allinterests
});
}

class SaveAboutMe extends AuthEvent{
  final String aboutme;

  SaveAboutMe({required this.aboutme});
}

class SaveRelationShipGoal extends AuthEvent{
  final String reltngoals;
  SaveRelationShipGoal({required this.reltngoals});
}

class SaveRelationShipType extends AuthEvent{
  final String relationtype;
  SaveRelationShipType({required this.relationtype});
}

class SaveLanguages extends AuthEvent{
  final String languages;
  SaveLanguages({required this.languages});
}

class SaveSelectedPet extends AuthEvent{
  final String pet;
  SaveSelectedPet({required this.pet});
}

class SaveDrinkingHabits extends AuthEvent{
  final String drinkinghabit;
  SaveDrinkingHabits({required this.drinkinghabit});
}

class SaveSmokingHabits extends AuthEvent{
  final String smokinghabits;
  SaveSmokingHabits({required this.smokinghabits});
}

class SaveDietPreferences extends AuthEvent{
  final String dietpreferences;
  SaveDietPreferences({
    required this.dietpreferences
});
}

class SaveJobTitle extends AuthEvent{
  final String jobtitle;
  SaveJobTitle({
    required this.jobtitle
});
}

class SaveCompanyName extends AuthEvent{
  final String companyname;
  SaveCompanyName({required this.companyname});
}

class SaveEducation extends AuthEvent{
  final String education;
  SaveEducation({required this.education});
}