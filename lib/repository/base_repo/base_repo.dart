///Base repository class which will return header
class BaseRepo {


  Future<Map<String, dynamic>> header() async {
    String token = "";
    Map<String, dynamic> headers = Map();
    //User response = await userData();
    //token = response != null ? response.token : AppConstants.user.token;
    headers['Authorization'] = 'Bearer $token';
    headers['content-type'] = 'application/json';
    print(headers);
    print('Token :: $token');
    return headers;
  }

  Future<String> token() async {
    //User user = await userData();
    String appToken = "";
    /*if (user != null) {
      appToken = user.token;
    }*/
    return appToken;
  }
}
