# libopencm3 example CMake subsystem
#
# (c) 2022 by Matthias Arndt <marndt@asmsoftware.de>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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

set(OPENCM3_COMPILE_OPTIONS "-fno-common -mcpu=cortex-m3 -mthumb -msoft-float -mfix-cortex-m3-ldrd")

# basic macro to create executables with .elf, .hex, .lst and .map output for STM32 Bluepill
# libopencm3 is linked
#
#
macro(add_bluepill_executable_64K target_name)

	# define file names we will be using
	set(elf_file ${target_name}.elf)
	set(map_file ${target_name}.map)
	set(hex_file ${target_name}.hex)
	set(lst_file ${target_name}.lst)


	# add elf target
	add_executable(${elf_file}
		${ARGN}
	)
    target_compile_definitions(${elf_file} PUBLIC "-DSTM32F1")
    target_link_libraries(${elf_file} stm32f103)

	# set compile and link flags for elf target
	set_target_properties(
		${elf_file}

		PROPERTIES
			COMPILE_FLAGS "${OPENCM3_COMPILE_OPTIONS}"
			LINK_FLAGS    "-T ${PROJECT_SOURCE_DIR}/bluepill-64K.ld -T ${OPENCM3_LD_SCRIPT} --static -nostartfiles -fno-common -Wl,--gc-sections -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group -Wl,-Map=${map_file}"
	)


	# generate the lst file
	add_custom_command(
		OUTPUT ${lst_file}

		COMMAND
			${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lst_file}

		DEPENDS ${elf_file}		
	)

	# create hex file
	add_custom_command(
		OUTPUT ${hex_file}

		COMMAND
			${CMAKE_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}

		DEPENDS ${elf_file}
	)

	# output section sizes
	add_custom_command(
		OUTPUT "print-size-${elf_file}"

		COMMAND
			${CMAKE_SIZE_UTIL} ${elf_file}

		DEPENDS ${elf_file}
	)

	# build the intel hex file for the device
	add_custom_target(
		${target_name}
		ALL
		DEPENDS ${hex_file} ${lst_file} "print-size-${elf_file}"
	)

	set_target_properties(
		${target_name}

		PROPERTIES
			OUTPUT_NAME ${elf_file}
	)

endmacro(add_bluepill_executable_64K)