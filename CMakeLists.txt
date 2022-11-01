cmake_minimum_required(VERSION 3.10)

project(opencm3-blinky)

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE Debug CACHE STRING
       "Choose the type of build, options are: None Debug Release RelWithDebInfo
MinSizeRel."
       FORCE )
endif()

include(opencm3.cmake)

add_bluepill_executable_64K( opencm3-blinky
	main.c
)
