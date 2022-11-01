/**
 * 
 * @file main.c
 * @author Matthias Arndt <marndt@asmsoftware.de>
 * @brief blink example with libopencm3
 * @details This runs on STM32 Blue pill board with 16MHz HSE.
 * 
 */

#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/flash.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/cm3/nvic.h>
#include <libopencm3/cm3/systick.h>

volatile uint32_t millis;  /**< ms counter driven vom Systick */

uint32_t time_on_ms = 300;
uint32_t time_off_ms = 700;

/**
 * @brief Systick handler as defined by libopencm3
 */
void sys_tick_handler ( void )
{
	millis++;  /**< ms counter driven vom Systick */
}

int main ( void )
{	
	rcc_clock_setup_pll ( &rcc_hse_configs[RCC_CLOCK_HSE16_72MHZ] );
	
	rcc_periph_clock_enable ( RCC_GPIOC );
	gpio_set_mode ( GPIOC, GPIO_MODE_OUTPUT_2_MHZ, GPIO_CNF_OUTPUT_PUSHPULL, GPIO13 );
	gpio_clear ( GPIOC, GPIO13 );

	/* 72MHz / 8 => 9000000 counts per second */
	systick_set_clocksource ( STK_CSR_CLKSOURCE_AHB_DIV8 );
	systick_set_reload ( 8999 ); /* 1000 overflows per second <=> ms  */
	systick_interrupt_enable();
	systick_counter_enable();

	for ( ;; )
	{
		if ( millis == time_on_ms )
		{
			gpio_clear ( GPIOC, GPIO13 );
		}

		if ( millis == time_off_ms )
		{
			gpio_set ( GPIOC, GPIO13 );
		}

		if ( millis >= (time_on_ms + time_off_ms) )
		{
			millis = 0;
		}
	}
}
