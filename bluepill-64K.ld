/* Define memory regions for use with libopenm3.- STM32F103R8 with 64K FLASH */
MEMORY
{
	rom (rx) : ORIGIN = 0x08000000, LENGTH = 64K
	ram (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}
