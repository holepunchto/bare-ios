cmake_minimum_required(VERSION 3.25)

project(bare_ios C OBJC)

include(bare)
include(ios)

install_node_modules()

add_subdirectory(vendor/bare-kit EXCLUDE_FROM_ALL)

add_executable(bare_ios)

set_target_properties(
  bare_ios
  PROPERTIES
  C_STANDARD 99
  OBJC_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
  OUTPUT_NAME Bare
)

add_bare_bundle(
  ENTRY app/app.js
  OUT app/app.bundle
  PREBUILDS
)

target_sources(
  bare_ios
  PRIVATE
    app/app.bundle
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

add_ios_bundle_info(
  bare_ios_info
  NAME Bare
  VERSION 1.0.0
  IDENTIFIER to.holepunch.bare.ios
  PUBLISHER_DISPLAY_NAME "Holepunch Inc"
  TARGET bare_ios
)

add_ios_iconset(
  bare_ios_icon
  ICONS
    app/icon.png 512 2x
)

add_ios_bundle(
  bare_ios_bundle
  DESTINATION Bare.app
  TARGET bare_ios
  DEPENDS bare_ios_icon
  RESOURCES
    FILE app/app.bundle .
    DIR app/prebuilds prebuilds
)
