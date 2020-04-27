// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

class DOMInjectorImpl {
  static void inject() {
    final head = html.querySelector('head');
    final html.ScriptElement mainDartVer = html.querySelector('body > script');
    final appVersion = mainDartVer?.src?.contains('v=') == true
        ? mainDartVer.src.split('v=').last
        : null;
    head.appendHtml(
      '''<script id="version-checker-script">
var appVersion = "${appVersion?.isNotEmpty == true ? appVersion : '0.0.0'}";

function hardReload() {
  setTimeout(function () {
    window.location.reload(true);
  }, 100);
}
</script>''',
      treeSanitizer: html.NodeTreeSanitizer.trusted,
    );
  }
}
