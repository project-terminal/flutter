// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path/path.dart' as path;

import 'base_code_gen.dart';
import 'key_data.dart';
import 'utils.dart';

/// Generates the key mapping of iOS, based on the information in the key
/// data structure given to it.
class IosCodeGenerator extends PlatformCodeGenerator {
  IosCodeGenerator(KeyData keyData) : super(keyData);

  /// This generates the map of iOS key codes to physical keys.
  String get _iosScanCodeMap {
    final StringBuffer iosScanCodeMap = StringBuffer();
    for (final Key entry in keyData.data) {
      if (entry.iosScanCode != null) {
        iosScanCodeMap.writeln('  { ${toHex(entry.iosScanCode)}, ${toHex(entry.usbHidCode)} },    // ${entry.constantName}');
      }
    }
    return iosScanCodeMap.toString().trimRight();
  }

  /// This generates the map of iOS number pad key codes to logical keys.
  String get _iosNumpadMap {
    final StringBuffer iosNumPadMap = StringBuffer();
    for (final Key entry in numpadKeyData) {
      if (entry.iosScanCode != null) {
        iosNumPadMap.writeln('  { ${toHex(entry.iosScanCode)}, ${toHex(entry.flutterId, digits: 10)} },    // ${entry.constantName}');
      }
    }
    return iosNumPadMap.toString().trimRight();
  }

  @override
  String get templatePath => path.join(flutterRoot.path, 'dev', 'tools', 'gen_keycodes', 'data', 'keyboard_map_ios_cc.tmpl');

  @override
  String outputPath(String platform) => path.joinAll(<String>[flutterRoot.path, '..', 'engine', 'src', 'flutter', 'shell', 'platform', 'darwin', platform, 'keycodes', 'keyboard_map_$platform.h']);

  @override
  Map<String, String> mappings() {
    // There is no iOS keycode map since iOS uses keycode to represent a physical key.
    // The LogicalKeyboardKey is generated by raw_keyboard_macos.dart from the unmodified characters
    // from NSEvent.
    return <String, String>{
      'IOS_SCAN_CODE_MAP': _iosScanCodeMap,
      'IOS_NUMPAD_MAP': _iosNumpadMap
    };
  }
}
