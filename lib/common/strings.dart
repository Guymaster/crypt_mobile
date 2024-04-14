String complteTo128(String str){
  String result = str;
  while(result.length < 32){
    result = "${result}_";
  }
  return result;
}