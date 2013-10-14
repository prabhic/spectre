/*
  Copyright (C) 2013 John McCutchan

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

library spectre_material_program_element;

import 'package:polymer/polymer.dart';
import 'package:spectre/spectre.dart';
import 'package:spectre/spectre_declarative.dart';
import 'package:spectre/spectre_elements.dart';

@CustomTag('s-material-program')
class SpectreMaterialProgramElement extends SpectreElement {
  @published String vertexShaderId = '';
  @published String fragmentShaderId = '';

  ShaderProgram _program;
  ShaderProgram get program => _program;

  void created() {
    super.created();
    init();
  }

  void inserted() {
    super.inserted();
  }

  void removed() {
    super.removed();
    if (inited) {
      _destroy();
    }
  }

  void init() {
    if (inited) {
      // Already initialized.
      return;
    }
    if (!declarativeInstance.inited) {
      // Not ready to initialize.
      return;
    }
    // Initialize.
    super.init();
    _create();
    var vertexShader = _findVertexShader();
    var fragmentShader = _findFragmentShader();
    _linkShaders(vertexShader, fragmentShader);
  }

  void _create() {
    assert(inited);
    var device = declarativeInstance.graphicsDevice;
    _program = new ShaderProgram('SpectreMaterialProgramElement', device);
    SpectreElement.log.info('Created ShaderProgram for $id');
  }

  SpectreVertexShaderElement _findVertexShader() {
    var element;
    String id = vertexShaderId;
    try {
      element = document.query(id);
    } catch (_) {}
    if (element == null) {
      element = this.query('s-vertex-shader');
    }
    if (element != null) {
      element = element.xtag;
      if (element is! SpectreVertexShaderElement) {
        element = null;
      }
    }
    if (element != null) {
      (element as SpectreElement).init();
    }
    return element;
  }

  SpectreFragmentShaderElement _findFragmentShader() {
    var element;
    String id = fragmentShaderId;
    try {
      element = document.query(id);
    } catch (_) {}
    if (element == null) {
      element = this.query('s-fragment-shader');
    }
    if (element != null) {
      element = element.xtag;
      if (element is! SpectreFragmentShaderElement) {
        element = null;
      }
    }
    if (element != null) {
      (element as SpectreElement).init();
    }
    return element;
  }

  void _linkShaders(SpectreVertexShaderElement vs,
                    SpectreFragmentShaderElement fs) {
    assert(inited);
    if (vs == null) {
      _program.vertexShader = null;
    } else {
      vs.init();
      _program.vertexShader = vs.shader;
    }
    if (fs == null) {
      _program.fragmentShader = null;
    } else {
      fs.init();
      _program.fragmentShader = fs.shader;
    }
    _program.link();
  }

  void _destroy() {
    assert(inited);
    _program.dispose();
  }
}
