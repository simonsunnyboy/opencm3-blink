cmake_minimum_required(VERSION 3.10)

project(opencm3-blinky)

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE Debug CACHE STRING
       "Choose the type of build, options are: None Debug Release RelWithDebInfo
MinSizeRel."
       FORCE )
endif()

include(opencm3.cmake)

set(ELF opencm3-blinky.elf)

add_executable( ${ELF}
	main.c
)

target_link_libraries(${ELF} -T "${PROJECT_SOURCE_DIR}/bluepill-64K.ld" -T "${OPENCM3_LD_SCRIPT}" --static -nostartfiles -fno-common -Wl,--gc-sections -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group stm32f103)
