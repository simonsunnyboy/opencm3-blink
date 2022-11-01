cmake_minimum_required(VERSION 3.10)

project(opencm3-blinky)

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE Debug CACHE STRING
       "Choose the type of build, options are: None Debug Release RelWithDebInfo
MinSizeRel."
       FORCE )
endif()

set(OPENCM3_DIR /home/marndt/Projects.git/libopencm3)

if(NOT EXISTS ${OPENCM3_DIR}/lib/libopencm3_stm32f1.a)
       message( FATAL_ERROR "libopencm3 missing, set OPENCM3_DIR environment variable." )
else()
       set(libopencm3_SOURCE_DIR ${OPENCM3_DIR})
       set(OPENCM3_LD_SCRIPT ${OPENCM3_DIR}/lib/cortex-m-generic.ld)
       set(OPENCM3_LIB ${OPENCM3_DIR}/lib/libopencm3_stm32f1.a)
       include_directories(${OPENCM3_DIR}/include)
endif()

if(NOT EXISTS ${OPENCM3_LD_SCRIPT})
       message(FATAL_ERROR "Linker script not found!")
endif()
#--

# Create a specific CPU target with the appropriate options etc
add_library(stm32f103 STATIC IMPORTED)
set_property(TARGET stm32f103 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${libopencm3_SOURCE_DIR}/include)
set_property(TARGET stm32f103 PROPERTY IMPORTED_LOCATION ${libopencm3_SOURCE_DIR}/lib/libopencm3_stm32f1.a)

#target_link_directories(stm32f103 INTERFACE ${libopencm3_SOURCE_DIR}/lib)

#target_compile_definitions(stm32f103 INTERFACE -DSTM32F1)

set(COMPILE_OPTIONS 
  --static
  -nostartfiles
  -fno-common
  -mcpu=cortex-m3
  -mthumb
  -msoft-float
  -mfix-cortex-m3-ldrd
  -DSTM32F1
)
#target_compile_options(stm32f103 INTERFACE ${COMPILE_OPTIONS})
#target_link_options(stm32f103 INTERFACE ${COMPILE_OPTIONS})
#---

add_definitions(${COMPILE_OPTIONS})

set(ELF opencm3-blinky.elf)

add_executable( ${ELF}
	main.c
)

target_link_libraries(${ELF} -T "${PROJECT_SOURCE_DIR}/bluepill-64K.ld" -T "${OPENCM3_LD_SCRIPT}" --static -nostartfiles -fno-common -Wl,--gc-sections -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group stm32f103)
