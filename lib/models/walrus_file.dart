import 'dart:convert';

class WalrusFile {
  final String blobId;
  final String shareLink;
  final DateTime uploadDate;

  WalrusFile({required this.blobId, required this.shareLink, required this.uploadDate});

  // URL để xem ảnh từ Walrus Testnet
  static const String _aggregatorUrl = "https://aggregator.walrus-testnet.walrus.space/v1";
  static String createLink(String id) => "$_aggregatorUrl/$id";

  Map<String, dynamic> toMap() => {
    'blobId': blobId,
    'shareLink': shareLink,
    'uploadDate': uploadDate.toIso8601String(),
  };

  factory WalrusFile.fromMap(Map<String, dynamic> map) => WalrusFile(
    blobId: map['blobId'],
    shareLink: map['shareLink'],
    uploadDate: DateTime.parse(map['uploadDate']),
  );

  String toJson() => json.encode(toMap());
  factory WalrusFile.fromJson(String source) => WalrusFile.fromMap(json.decode(source));
}