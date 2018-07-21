cmake_minimum_required(VERSION 3.10)
project(Neon)

set(SWIFT_CHECKOUTS_DIR "${CMAKE_SOURCE_DIR}/.build/checkouts")
set(SWIFT_SOURCE_DIR "${CMAKE_SOURCE_DIR}/Sources")

file(GLOB_RECURSE SWIFT_SOURCES ${SWIFT_SOURCE_DIR}/*.swift)

add_custom_target(Neon
                  COMMAND /home/clanat/.swiftenv/versions/4.1.2/usr/bin/swift build
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                  SOURCES ${SWIFT_SOURCES})
