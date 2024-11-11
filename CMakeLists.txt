cmake_minimum_required(VERSION 3.25)

find_package(cmake-bare-bundle REQUIRED PATHS node_modules/cmake-bare-bundle)
find_package(cmake-fetch REQUIRED PATHS node_modules/cmake-fetch)
find_package(cmake-ios REQUIRED PATHS node_modules/cmake-ios)
find_package(cmake-npm REQUIRED PATHS node_modules/cmake-npm)

project(bare_ios C OBJC)

install_node_modules()

fetch_package("github:holepunchto/bare-kit")

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
  bare_ios_app
  ENTRY app/app.js
  OUT app/app.bundle
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

get_target_property(BARE_KIT_BINARY_DIR bare_kit BINARY_DIR)

add_ios_bundle(
  bare_ios_bundle
  DESTINATION Bare.app
  TARGET bare_ios
  DEPENDS bare_ios_icon
  RESOURCES
    FILE app/app.bundle .
    DIR ${BARE_KIT_BINARY_DIR}/BareKit.framework Frameworks/BareKit.framework
)
