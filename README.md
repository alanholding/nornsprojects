# norns projects

Some [monome norns](https://monome.org/norns/) scripting projects by me. Only one so far! :)

## midi2crow

This script converts MIDI notes received by norns into control voltage (CV) pitch and gate values and asks crow to send those values to output ports 1 and 2.

This was done as my own study exercise in writing a norns script for the first time.

Currently at the "it works for me" version 0.1 stage, which is monophonic and very basic. It does not do things like detect which norns MIDI port or MIDI channel you want to use, or have a fancy GUI or other options. It just takes in MIDI notes on the default norns port and channel (?), converts them to CV values, asks crow to output them, and then prints some status information to the norns screen.

I will add more fancy things as I get more confident in scripting. :)

### Requirements

You will need:

* Something that makes MIDI notes (a MIDI keyboard is good!).
* A [monome norns](https://monome.org/norns/) or [monome norns shield](https://monome.org/docs/norns/shield/).
* A [monome crow](https://monome.org/docs/crow/).
* Electricity (of some form).
* USB cables.
* Eurorack modules.

### Loading and running.

To load this script onto your norns and run it, try the following:

1. [Connect to your norns](https://monome.org/docs/norns/wifi-files/#transfer).
2. Copy the folder `alanholding` from this repository to inside the `dust/code` folder on your norns.
3. Restart your norns. (I'm not sure if you really need to do this step, but it can't hurt?)
4. Following the instructions on [how to select scripts on your norns](https://monome.org/docs/norns/play/#select), select the script `ALANHOLDING/MIDI2CROW` and run it.

### How to use

1. Connect a MIDI note making thing to your norns via USB.
2. Connect your norns to your friendly neighbourhood crow.
3. Connect crow's output 1 to the pitch 1v/oct input of a Eurorack module which likes pitch.
4. Connect crow's output 2 to a Eurorack module which likes gates.
5. Do whatever it is you do to get sound out of your Eurorack modules.
6. Play MIDI notes and hopefully you will hear something.

### Future possibilities

* Print more nice things to the norns screen, like:
  * A flashing blob thing to indicate notes are playing.
  * MIDI note names and MIDI note values, e.g., 60 c4, showing above a fancy pants keyboard graphic?
* Convert MIDI note velocity to CV. This will mean grokking advanced lists in Lua, which will make my brain hurt.
* Process MIDI pitch bend?
* Convert MIDI note aftertouch to CV?
* Add an octave switcher, because why not?
* Change the `cv_gate` variable to a true / false value and then use crow's [ASL](https://monome.org/docs/crow/reference/#asl) to do interesting things with envelopes and CV, rather that just setting the gate output to open or closed?
