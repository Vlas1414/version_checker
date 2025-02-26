// Copyright (c) 2021, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

class VersionHelperImpl {
  static void refresh() => js.context.callMethod('hardReload');

  static Future<Version> getActualVersion() async {
    try {
      final isLocalhost = html.window.location.host.contains('localhost') ||
          html.window.location.host.contains('127.0.0.1');
      final url =
          '${isLocalhost ? 'http' : 'https'}://${html.window.location.host}/assets'
          '/packages/version_checker/assets/env.json?v=${DateTime.now().millisecondsSinceEpoch}';
      final res = await http.get(Uri.parse(url));
      final Map<String, dynamic> map = json.decode(res.body);
      return Version.parse((map['app_version'] as String?) ?? '0.0.0');
    } catch (e, stackTrace) {
      // TODO: add ability to handle customly errors
      print(
          '[version_checker] error occured:\n${e.toString()}\n\n${stackTrace.toString()}');
      return Version(0, 0, 0);
    }
  }

  static Future<Version> getAppVersion() async {
    final html.ScriptElement script =
        html.querySelector('#version-checker-script') as html.ScriptElement;
    final version = RegExp('var appVersion = \"([0-9]*\.[0-9]*\.[0-9]*)\"')
        .firstMatch(script.innerHtml!)!
        .group(1)!;

    return Version.parse(version);
  }
}
