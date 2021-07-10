import 'package:morphosis_flutter_demo/non_ui/modal/photo.dart';
import 'package:http/http.dart' as http;

class ApiConnection {
  static ApiConnection _apiInstance;

  ApiConnection._();

  static ApiConnection get apiInstance {
    if (_apiInstance == null) {
      _apiInstance = ApiConnection._();
    }
    return _apiInstance;
  }

  static String apiAuthKeys =
      '563492ad6f91700001000001a60a1a4ddf2846c6b3aaa7028ce63c63';
  static String baseUrl = 'https://api.pexels.com/v1/';

  static Map<String, String> header = {'Authorization': apiAuthKeys};

  Future<List<Photo>> getPhotosFromAPI(int pageNumber) async {
    var response = await http.get(
        Uri.parse(
            baseUrl + 'curated?page=' + pageNumber.toString() + '&per_page=20'),
        headers: header);

    return photoFromJson(response.body);
  }
}
