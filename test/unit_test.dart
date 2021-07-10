import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/photo.dart';
import 'package:morphosis_flutter_demo/non_ui/provider/DataProvider.dart';
import 'package:morphosis_flutter_demo/main.dart' as appMain;

void main() async {
  appMain.main();
  test(
      'Chenking If Search is Working on Home Page and retuning a List of Photos',
      () async {
    DataNotifier dataNotifier = new DataNotifier();
    List<Photo> list = [];

    dataNotifier.searchFromLocalDB('Aa');
    expect(list, dataNotifier.searchedPhotos);
  });
}
