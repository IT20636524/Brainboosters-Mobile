class FormValidators {
  bool validateEmail(String email) {
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    final regex = RegExp(pattern);

    if (email.isEmpty) {
      return false;
    }

    if (!regex.hasMatch(email)) {
      return false;
    }

    return true;
  }

  bool validatePassword(String password) {
    if (password.length < 6) {
      return false;
    }

    return true;
  }

  bool matchPasswords(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return false;
    }

    return true;
  }

  bool fullNameValidator(String fullName) {
    final nameParts = fullName.split(' ');

    if (nameParts.length < 2) {
      return false;
    }

    return true;
  }
}
