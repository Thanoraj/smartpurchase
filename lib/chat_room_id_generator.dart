class ChatRoomGenerator {
  static String getChatRoomId({String a, String b}) {
    if (a.length > b.length) {
      return '${b}_$a';
    } else if (a.length == b.length) {
      for (int i = 0; i < a.length; i++) {
        if (a.substring(i, i + 1) == b.substring(i, i + 1)) {
          continue;
        } else {
          if (a.substring(i, i + 1).codeUnitAt(0) <
              b.substring(i, i + 1).codeUnitAt(0)) {
            return '${a}_$b';
          } else {
            return '${b}_$a';
          }
        }
      }
    } else {
      return '${a}_$b';
    }
  }

  static List getChatRoomUsers({String a, String b}) {
    if (a.length > b.length) {
      return [b, a];
    } else if (a.length == b.length) {
      for (int i = 0; i < a.length; i++) {
        if (a.substring(i, i + 1) == b.substring(i, i + 1)) {
          continue;
        } else {
          if (a.substring(i, i + 1).codeUnitAt(0) <
              b.substring(i, i + 1).codeUnitAt(0)) {
            return [a, b];
          } else {
            return [b, a];
          }
        }
      }
    } else {
      return [a, b];
    }
  }
}
