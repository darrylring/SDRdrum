# SDRdrum

SDRdrum is a software-defined radio (SDR) implementation of the Radio Drum: a 3D
gestural capacitive sensor developed at Bell Labs in the 1980s. Originally
created by Bob Boie, one of the pioneers of capacitive sensing, it was intended
to be a 3D computer mouse. Instead, the Radio Drum has found notability as an
instrument for computer music due to the [work][paper] of Max Mathews and
[Andrew Schloss][andy].

While the early Radio Drum implementations used analog signal processing
techniques and 1980s digital electronics, the SDRdrum's signal processing is
completely digital.

[paper]: https://quod.lib.umich.edu/i/icmc/bbp2372.1989.010/--radio-drum-as-a-synthesizer-controller?view=image
[andy]: https://people.finearts.uvic.ca/~aschloss

## License

The SDRdrum's firmware, FPGA logic, and host software (contained within the
`firmware`, `fpga`, and `host` directories respectively) are free software, and
may be modified and redistributed under the terms of the [GNU General Public License][gpl]
(GPL) version 3 or later.

The hardware designs contained in the `boards` directory are licensed under the
[CERN Open Hardware License][ohl] v1.2.

[gpl]: https://www.gnu.org/licenses/gpl-3.0.en.html
[ohl]: https://www.ohwr.org/licenses/cern-ohl/license_versions/v1.2
