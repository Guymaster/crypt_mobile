String? entityNameValidator(String? value) {
  if(value == null || value.isEmpty){
    return "Don't forget to provide a name";
  }
  if(value.length < 3){
    return "Too short";
  }
  if(value.length > 50){
    return "Too long";
  }
}