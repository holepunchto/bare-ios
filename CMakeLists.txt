cmake_minimum_required(VERSION 3.25)

project(
  bare_ios
  VERSION 1.0
  LANGUAGES C CXX
)

include(bare)

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
    app/main.c
)

target_include_directories(
  bare_ios
  PUBLIC
    $<TARGET_PROPERTY:bare,INTERFACE_INCLUDE_DIRECTORIES>
)

add_executable(bare_ios_bin)

set_target_properties(
  bare_ios_bin
  PROPERTIES
  OUTPUT_NAME bare

  MACOSX_BUNDLE_GUI_IDENTIFIER bare
  MACOSX_BUNDLE_BUNDLE_NAME bare
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_INFO_STRING ${PROJECT_VERSION}
  MACOSX_BUNDLE_LONG_VERSION_STRING ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
)

target_link_libraries(
  bare_ios_bin
  PUBLIC
    bare_ios
  PRIVATE
    $<LINK_LIBRARY:WHOLE_ARCHIVE,bare_static>
)

install(
  TARGETS bare_ios_bin
  BUNDLE DESTINATION ${target}
)
