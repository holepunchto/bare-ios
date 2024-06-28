cmake_minimum_required(VERSION 3.25)

project(bare_ios LANGUAGES C OBJC VERSION 1.0)

include(bare)

install_node_modules()

add_subdirectory(vendor/bare-kit EXCLUDE_FROM_ALL)

add_executable(bare_ios MACOSX_BUNDLE)

set_target_properties(
  bare_ios
  PROPERTIES
  C_STANDARD 99
  OBJC_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
  OUTPUT_NAME Bare

  MACOSX_BUNDLE_GUI_IDENTIFIER to.holepunch.bare.ios
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
)

add_bare_bundle(
  ENTRY app/app.js
  OUT app/app.bundle.h
  TARGET c
)

target_sources(
  bare_ios
  PRIVATE
    app/app.bundle.h
    app/AppDelegate.h
    app/AppDelegate.m
    app/main.m
)

target_link_libraries(
  bare_ios
  PUBLIC
    "-framework UIKit"
  PRIVATE
    bare_kit
)

link_bare_modules(bare_ios)
