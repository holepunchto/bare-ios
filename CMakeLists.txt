cmake_minimum_required(VERSION 3.25)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(WIN32)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

project(pear_ios C)

include(pear)

set(PEAR_USE_JAVASCRIPTCORE ON)

add_subdirectory(vendor/pearjs EXCLUDE_FROM_ALL)

add_library(pear_ios OBJECT)

set_target_properties(
  pear_ios
  PROPERTIES
  C_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
)

find_program(node NAMES node)

add_custom_command(
  COMMAND ${node} scripts/link.mjs
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  OUTPUT
    ${PROJECT_SOURCE_DIR}/bin/app.js
    ${PROJECT_SOURCE_DIR}/bin/app.js.h
  DEPENDS
    src/app.js
  VERBATIM
)

target_sources(
  pear_ios
  PRIVATE
    bin/app.js.h
    bin/main.c
)

target_include_directories(
  pear_ios
  PUBLIC
    $<TARGET_PROPERTY:pear,INTERFACE_INCLUDE_DIRECTORIES>
)

add_executable(pear_ios_bin $<TARGET_OBJECTS:pear_ios>)

add_debug_options(pear_ios_bin)

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

install(
  TARGETS pear_ios_bin
  BUNDLE DESTINATION ${PEAR_PLATFORM}
)

install(
  FILES bin/Info.plist
  DESTINATION ${PEAR_PLATFORM}/Pear.app
)
