# libopencm3 example CMake subsystem
#
# (c) 2022 by Matthias Arndt <marndt@asmsoftware.de>
#

set(OPENCM3_DIR /opt/libopencm3 CACHE PATH "Search path for libopencm3")

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