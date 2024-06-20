cmake_minimum_required(VERSION 3.25)

project(bare_ios LANGUAGES C OBJC VERSION 1.0)

include(bare)

install_node_modules()

bare_target(target)

add_subdirectory(vendor/bare EXCLUDE_FROM_ALL)

add_library(bare_ios OBJECT)

set_target_properties(
  bare_ios
  PROPERTIES
  C_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
)

add_bare_bundle(
  ENTRY app/main.js
  OUT app/main.bundle.h
  TARGET c
)

target_sources(
  bare_ios
  PRIVATE
    app/main.bundle.h
    app/main.m
    app/AppDelegate.h
    app/AppDelegate.m
    app/Worker.h
    app/Worker.m
)

target_include_directories(
  bare_ios
  PUBLIC
    $<TARGET_PROPERTY:bare,INTERFACE_INCLUDE_DIRECTORIES>
)

target_link_libraries(
  bare_ios
  PUBLIC
    "-framework Foundation"
    "-framework UIKit"
)

add_executable(bare_ios_bin MACOSX_BUNDLE)

set_target_properties(
  bare_ios_bin
  PROPERTIES
  OUTPUT_NAME bare

  MACOSX_BUNDLE_GUI_IDENTIFIER bare
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
)

target_link_libraries(
  bare_ios_bin
  PUBLIC
    bare_ios
  PRIVATE
    $<LINK_LIBRARY:WHOLE_ARCHIVE,bare_static>
)

link_bare_modules(bare_ios_bin)
