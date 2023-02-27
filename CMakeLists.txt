cmake_minimum_required(VERSION 3.25)

project(
  pear_ios
  VERSION 1.0
  LANGUAGES C CXX
)

include(pear)

pear_target(target)

add_subdirectory(vendor/pearjs EXCLUDE_FROM_ALL)

add_library(pear_ios OBJECT)

set_target_properties(
  pear_ios
  PROPERTIES
  C_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
)

add_pear_bundle(
  ENTRY src/app.js
  OUT bin/main.bundle.h
  TARGET c
)

target_sources(
  pear_ios
  PRIVATE
    bin/main.bundle.h
    bin/main.c
)

target_include_directories(
  pear_ios
  PUBLIC
    $<TARGET_PROPERTY:pear,INTERFACE_INCLUDE_DIRECTORIES>
)

add_executable(pear_ios_bin $<TARGET_OBJECTS:pear_ios>)

set_target_properties(
  pear_ios_bin
  PROPERTIES
  OUTPUT_NAME Pear

  MACOSX_BUNDLE_BUNDLE_NAME Pear
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_INFO_STRING ${PROJECT_VERSION}
  MACOSX_BUNDLE_LONG_VERSION_STRING ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
)

target_link_libraries(
  pear_ios_bin
  PRIVATE
    $<LINK_LIBRARY:WHOLE_ARCHIVE,pear_static>
)

link_pear_module(
  pear_ios_bin
  fx_native
  node_modules/fx-native
)

install(
  TARGETS pear_ios_bin
  BUNDLE DESTINATION ${target}
)
