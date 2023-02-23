cmake_minimum_required(VERSION 3.25)

project(pear_ios C CXX)

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

install(
  FILES bin/Info.plist
  DESTINATION ${target}/Pear.app
)
