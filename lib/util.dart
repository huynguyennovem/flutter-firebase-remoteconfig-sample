import 'dart:convert';

import 'package:blog_firebase_remoteconfig/user_entity.dart';
import 'package:flutter/foundation.dart';

class Util {

  Future<UserEntity> parseJsonConfig(String rawJson) async {
    final Map<String, dynamic> parsed = await compute(decodeJsonWithCompute, rawJson);
    final mobileAdsEntity = UserEntity.fromJson(parsed);
    return mobileAdsEntity;
  }

  static Map<String, dynamic> decodeJsonWithCompute(String rawJson) {
    return jsonDecode(rawJson);
  }

}