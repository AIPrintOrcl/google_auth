// Firebase Firestore와의 데이터 상호작용, 디바이스 정보 획득, 특정 데이터의 상태 확인 및 설정


/*
Future<void> updateUserDB(FirebaseFirestore db, data, bool needTimer) async {
  await db.collection(getUserCollectionName(getx.mode)).doc(getx.walletAddress.value).update(data);
}

Future<void> appendUserErrorDB(FirebaseFirestore db, Map<String, dynamic> data) async {
  DateTime currentTime = await NTP.now();
  print(data);
  data["time"] = currentTime.toUtc().add(Duration(hours: 9)).toString();
  data["timemillis"] = currentTime.millisecondsSinceEpoch;

  await db.collection(getUserCollectionName(getx.mode)).doc(getx.walletAddress.value)
      .collection("error").add(data);
}

Future<String> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final device_info = await deviceInfoPlugin.deviceInfo;

  if (Platform.isAndroid) {
    return device_info.data["id"].toString();
  } else if (Platform.isIOS) {
    return device_info.data["identifierForVendor"];
  }
  device_info.data.forEach((key, value) {
    print("index: " + key.toString() + ", value: " + value.toString());
  });

  return "no device info";
}*/
