#!/bin/bash

# Generate test tone
sox -r 48000 -c 2 -n sine.wav synth 10 sine 1000

# balanced input without Mic bias
amixer sset "ADC Mic Bias" "Mic Bias off"
amixer sset "ADC Left Input" "{VIN1P, VIN1M}[DIFF]"
amixer sset "ADC Right Input" "{VIN2P, VIN2M}[DIFF]"
echo
echo
echo

# Loop through several input/output gain settings
for outvol in 0 -10 -20 -30 -40 -50; do
	for invol in 0 10 20 30 40; do
		echo "${outvol}dB +${invol}dB"
		amixer sset "Digital" -- ${outvol}dB >/dev/null
		amixer sset "ADC" ${invol}dB >/dev/null
		sleep 1
		aplay sine.wav 2>/dev/null &
		./unitest -r 48000 2>/dev/null| grep RMS
		echo
		sleep 10
	done
done


