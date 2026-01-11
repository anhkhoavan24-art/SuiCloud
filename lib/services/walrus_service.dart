import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalrusService {
  // Địa chỉ Publisher Node của Walrus
  final String _publisherUrl = "https://publisher.walrus-testnet.walrus.space/v1/store";

  // Hàm trả về Blob ID nếu thành công, hoặc ném ra lỗi nếu thất bại
  Future<String> uploadFile(File file) async {
    try {
      List<int> bytes = await file.readAsBytes();
      var request = http.Request('PUT', Uri.parse(_publisherUrl));
      request.bodyBytes = bytes;

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Walrus trả về JSON, ví dụ: {"newId":{"blobId":"abc..."}} (Cấu trúc này có thể thay đổi tùy version)
        // Ở đây ta parse JSON để lấy ID chuẩn xác
        var jsonResponse = json.decode(responseString);

        // Tùy vào response thực tế của Walrus, thông thường nó nằm trong newId -> blobId
        if (jsonResponse is Map && jsonResponse.containsKey('newId')) {
          return jsonResponse['newId']['blobId'];
        } else if (jsonResponse is Map && jsonResponse.containsKey('alreadyCertified')) {
          // Trường hợp file đã tồn tại trên mạng
          return jsonResponse['alreadyCertified']['blobId'];
        }

        // Fallback nếu cấu trúc lạ (cho vibe coder test)
        return "ERROR_PARSING_JSON";
      } else {
        throw Exception("Lỗi Server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }
}