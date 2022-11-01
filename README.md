# libopencm3 blinky example for STM32 Blue Pill

(c) 2022 by Matthias Arndt <marndt@asmsoftware.de>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Abstract

Use a proper CMake toolchain in the following fashion to build.
<https://github.com/vpetrigo/arm-cmake-toolchains> works well.

## System requirements

- STM32 Bluepill board with STM32F103 MCU
- a means to program
- CMake
- ARM toolchain for Cortex-M

## libopencm3 integration

This project provides an example on integration of an existing libopencm3
build into a geenric project. The file opencm3.cmake expects to find the
library in the usual locations (/usr, /usr/local and /opt) but allows for
user side configuration.

Linkable libraries are provided for the STM32 Blue pill.

libopemcm3 is not build from this example. It uses existing binaries.

A CMake macro add_bluepill_executable is provided to build an executable
with all necessary flags, map and listing file to both .elf and .hex
formats.

## Linker file

The basic linker file is according to the libopencm3 standard.
The complete linker file from the stgandard is added to the minimum
memory map provided in the project specific linker file.
