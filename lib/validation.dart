String validateEmail(String value) {
  if (value.trim().isEmpty) {
    return 'Email is required';
  }
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter valid email';
  }
  return null;
}

String validateCode(String value) {
  if (value.trim().isEmpty) {
    return 'Code is required';
  }
  return null;
}

String validateFirstName(String value) {
  if (value.trim().isEmpty) {
    return 'First Name is required';
  }
  if (value.trim().length < 2) {
    return 'First Name too short';
  }
  Pattern pattern = r'^[a-zA-Z ]*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Only alphabets are allowed';
  }
  return null;
}

String validateLastName(String value) {
  if (value.length == 0) {
    return null;
  }
  Pattern pattern = r'^[a-zA-Z ]*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Only alphabets are allowed';
  }
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password too short';
  }
  return null;
}

String validateContactNo(String value) {
  if (value.isEmpty) {
    return 'Contact no is required';
  }
  Pattern pattern = r'^[0-9]*$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Only numbers are allowed';
  }
  if (value.length != 10) {
    return 'Contact no must be of 10 digits';
  }
  return null;
}

String validateAddress(String value) {
  if (value.isEmpty) {
    return 'Address is required';
  }
  return null;
}

String validateArea(String value) {
  if (value.isEmpty) {
    return 'Area is required';
  }
  return null;
}

String validateCity(String value) {
  return null;
}

String validateTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String validateAuthor(String value) {
    if (value.trim().isEmpty) {
      return 'Author is required';
    }
    if (value.trim().length < 2) {
      return 'Author too short';
    }
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }
    return null;
  }

  String validatePublication(String value) {
    return null;
  }

  String validateEdition(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    if (value.length > 2) {
      return 'Edition Limit Exceeded';
    }
    return null;
  }

  String validateLanguage(String value) {
    if (value.trim().isEmpty) {
      return 'Language is required';
    }

    if (value.trim().length < 2) {
      return 'Language is too short';
    }

    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }
    return null;
  }

  String validateDescription(String value) {
    return null;
  }

  String validateISBN(String value) {
    if (value.length == 0) {
      return null;
    }

    if (value.length != 13 && value.length != 10) {
      return 'ISBN should be of length 10 or 13';
    }
    return null;
  }

  String validateOTP(String value) {
    if (value.trim().isEmpty) {
      return 'OTP is required';
    }
    return null;
  }

  String validatePrice(String value) {
    if (value.trim().isEmpty) {
      return 'Price is required';
    }
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  String validateNoOfDays(String value) {
    if (value.trim().isEmpty) {
      return 'No. of days are required';
    }
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  String validateGenre(String value) {
    return null;
  }