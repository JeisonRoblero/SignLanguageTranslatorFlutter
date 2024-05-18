//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_acrylic/flutter_acrylic_plugin.h>
#include <serious_python_windows/serious_python_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterAcrylicPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAcrylicPlugin"));
  SeriousPythonWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SeriousPythonWindowsPluginCApi"));
}
