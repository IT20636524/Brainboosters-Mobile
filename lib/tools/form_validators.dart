class FormValidators {

  bool isEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool isConfirmPasswordValid(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool isFullNameValid(String fullName) {
    return fullName.length >= 8;
  }

  bool isNameValid(String fullName) {
    return fullName.length >= 5;
  }

  bool isAgeValid(String ageStr) {
    int? age = int.tryParse(ageStr);
    if (age == null) {
      // Age is not a valid integer.
      return false;
    }

    return age >= 18 && age <= 100;
  }

  bool isGenderValid(String gender) {
    return gender.isNotEmpty && (gender == 'male' || gender == 'female');
  }

  bool isContactNumberValid(String contactNumber) {
    final RegExp contactNumberRegex = RegExp(
      r'^[0-9]{10}$',
    );

    return contactNumberRegex.hasMatch(contactNumber);
  }

}