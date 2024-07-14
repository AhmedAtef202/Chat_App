import 'package:chatapp1/constants.dart';

class Message {
  final String message;
  final String id; // changed to String

  Message({required this.message, required this.id});

  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData[kMessage],
      id: jsonData['id']?.toString() ??
          '', // changed to 'id' and added null-safety check
    );
  }
}
