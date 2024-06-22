#include "JHermesRuntime.h"

using namespace facebook::jni;

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    return initialize(vm, [] {
        intuit::playerui::JHermesRuntime::registerNatives();
        intuit::playerui::JJSIValue::registerNatives();
    });
}
