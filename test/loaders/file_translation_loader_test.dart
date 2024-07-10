import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_asset_bundle.dart';
import '../test_asset_bundle_fallback.dart';
import '../test_loader.dart';

void main() {
  test('should have initial values', () {
    var instance = TestJsonLoader();
    expect(instance.fallbackFile, "en");
    expect(instance.basePath, isNotNull);
    expect(instance.useCountryCode, isFalse);
  });

  test('should load correct map', () async {
    var instance = FileTranslationLoader();
    instance.assetBundle = TestAssetBundle();

    var result = await instance.load();

    expect(result, isMap);
    expect(result, isEmpty);
  });

  test('should deep merge fallback map', () async {
    var instance = FileTranslationLoader(
        forcedLocale: Locale.fromSubtags(languageCode: "fr"),
        fallbackFile: "en");
    instance.assetBundle = TestAssetBundleFallbackFrToEn();

    var result = await instance.load();

    expect(result, isMap);
    expect(result, isNotEmpty);
    expect(result["title"], equals("flutter_18n_fr"));
    expect(result["sub_title"], equals("Hello World"));
    var block = result["block"];
    expect(block, isMap);
    expect(block, isNotEmpty);
    expect(block["label1"], equals("This is my app"));
    expect(block["label2"], equals("Bonjour"));
  });

  test('should skip merge fallback map', () async {
    var instance = FileTranslationLoader(
        forcedLocale: Locale.fromSubtags(languageCode: "fr"),
        fallbackFile: null);
    instance.assetBundle = TestAssetBundleFallbackFrToEn();

    var result = await instance.load();

    expect(result, isMap);
    expect(result, isNotEmpty);
    expect(result["title"], equals("flutter_18n_fr"));
    expect(result["sub_title"], equals(null));
    var block = result["block"];
    expect(block, isMap);
    expect(block, isNotEmpty);
    expect(block["label1"], equals(null));
    expect(block["label2"], equals("Bonjour"));
  });

  test('`loadString` should load correct string', () async {
    final instance = TestJsonLoader();
    final result = await instance.loadString("_fileName", "_extension");
    expect(result, contains("_fileName"));
    expect(result, contains("_extension"));
  });

  test('`load` should load correct map from JSON with initial values',
      () async {
    final instance = TestJsonLoader();
    final result = await instance.load();
    expect(result["fileName"], "en");
    expect(result["extension"], "json");
  });

  test('`load` should load correct map from YAML with initial values',
      () async {
    final instance = TestYamlLoader();
    final result = await instance.load();
    expect(result["fileName"], "en");
    expect(result["extension"], "yaml");
  });

  test('`load` should load correct map from TOML with initial values',
      () async {
    final instance = TestTomlLoader();
    final result = await instance.load();
    expect(result["fileName"], "en");
    expect(result["extension"], "toml");
  });

  test('`load` should load correct map from XML with initial values', () async {
    final instance = TestXmlLoader();
    final result = await instance.load();
    expect(result["fileName"], "en");
    expect(result["extension"], "xml");
  });

  test('`load` should load correct map with country code', () async {
    final instance = TestJsonLoader(useCountryCode: true);
    final result = await instance.load();
    expect(result["fileName"], "en_US");
    expect(result["extension"], "json");
  });

  test('`load` should load correct map with another locale', () async {
    final instance = TestJsonLoader(forcedLocale: Locale("ua"));
    final result = await instance.load();
    expect(result["fileName"], "ua");
    expect(result["extension"], "json");
  });

  test('`load` should load correct map from yaml file', () async {
    final instance = TestJsonLoader(forcedLocale: Locale("uk"));
    final result = await instance.load();
    expect(result["fileName"], "uk");
    expect(result["extension"], "yaml");
  });

  test(
      '`load` should load correct map with invalid locale and correct fallback locale',
      () async {
    final instance = TestJsonLoader(forcedLocale: Locale("_en"));
    final result = await instance.load();
    expect(result["fileName"], "en");
    expect(result["extension"], "json");
  });

  test(
      '`load` should load empty map with invalid locale and invalid fallback locale',
      () async {
    final instance =
        TestJsonLoader(forcedLocale: Locale("_en"), fallbackFile: "_en");
    final result = await instance.load();
    expect(result, isMap);
    expect(result, isEmpty);
  });
}
