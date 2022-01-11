-- midi2crow
-- v0.1
-- 
-- a simple monophonic
-- midi gate + note to
-- cv gate + pitch
-- converter for norns + crow

-- plug in a midi note generating thing into norns, then plug norns into crow.
-- connect crow cv output 1 to a eurorack module which likes pitch 1v/oct.
-- connect crow cv output 2 to a eurorack module which likes gates.
-- play nice

-- first, set up a variety of variables

-- m is proxy to norns midi interface. the norns library code does all the real fancy work.
m = midi.connect()

-- playing_note is used to remember the current playing note. takes its value from the most recent incoming midi note.
-- a number: e.g., 42.
playing_note = 0

-- midi_type is used to remember the most recent incoming midi message type.
-- a string: e.g., "note on".
midi_type = "el zilcho"

-- cv_gate is the value that will be sent from norns to crow to set the cv gate voltage.
-- a number: 0 is low / note off / gate closed, 10 is high / note on / gate open.
cv_gate = 0

-- cv is the value that will be sent from norns to crow to set the cv pitch (1 volt per octave) voltage.
-- this is just the playing_note value divided by twelve.
-- a number: e.g., 3.83333333.
cv = 0 

-- a list of the currently "held" note values.
-- a list of numbers: e.g., { 23, 42, 31, 60, 71 }.
note_list = {}

-- the actual midi to cv conversion stuff starts here.
-- this is where the limitations of the current version of this script might show itself, as i haven't tested the script further than my own limited usage of one midi controller keyboard connected to my norns receiving midi notes over midi channel 1 and then sending cv to my crow. but it works for me. :)

-- this function processes incoming midi events and does things when a note on or note off message is received.
m.event = function(data)
	-- convert the received midi message data into an easy to understand list.
	local midi_message_data = midi.to_msg(data)
	-- get the type of midi message.
	midi_type = midi_message_data.type
	-- if the midi message is a note on then:
	if midi_type == "note_on" then
		-- set the cv gate value to be high / open / 10 volts / "playing".
		cv_gate = 10
		-- get the midi note value.
		playing_note = midi_message_data.note
		-- add the new note to the note list.
		table.insert(note_list, playing_note)
	-- if the midi message is a note off then:
	elseif midi_type == "note_off" then
		-- remove the note from the note list
		remove_a_note_from_the_note_list(midi_message_data.note)
		-- if there are no notes left to play in the note list then:
		if #note_list == 0 then
			-- then there's no need to keep the cv gate open.
			cv_gate = 0
		-- but what if there is at least one note left in the note list?
		else
			-- then set the currently playing note to the last note in the note list.
			-- this means you can do trills and things!
			playing_note = note_list[#note_list]
		end
	end
	-- ok, we are now ready to send electricity to crow.
	-- convert the current playing note value to cv pitch 1v/oct using the power of mathematics!
	cv = playing_note / 12 -- science!
	-- limit the voltages sent to crow's output 1, just in case.
	if cv > 10 then cv = 10 end
	if cv < -5 then cv = -5 end
	-- send the cv pitch 1v/oct value to crow's output number 1.
	crow.output[1].volts = cv
	-- send the cv gate value to crow's output number 2.
	crow.output[2].volts = cv_gate
	-- finally, update the norns screen.
	redraw()
end
-- end of the midi event processing function.

-- initialise nornsy mcnornsface!
function init()
	-- set the brightness of the norns display to SUPER BRIGHT MAXIMUM MY EYES!!!1!
	screen.level(15)
	-- turn off anti-aliasing.
	screen.aa(0)
	-- set the drawing line width.
	-- i'm not sure if this is needed, but it was in the norns studies examples, so remain it shall.
	screen.line_width(1)
	-- the screen font and other things are left at the default settings.
end
-- end of init(), innit?

-- norns screen stuff
function redraw()
	-- clear the screen.
	screen.clear()
	-- describe the stuff which we want printed to the screen and where it should go.
	screen.move(10,10)
	screen.text("midi msg type: "..midi_type)
	screen.move(10,20)
	screen.text("playing note: "..string.format("%d",playing_note))
	screen.move(10,30)
	screen.text("note count: "..string.format("%d",#note_list))
	screen.move(10,50)
	screen.text("cv gate: "..string.format("%d",cv_gate))
	screen.move(10,60)
	screen.text("cv: "..string.format("%f",cv))
	-- print the stuff to the screen.
	screen.update()
end
-- end of redraw()

-- this function removes the last occurance of the specified note from the note list. this is so that if you have more than one note playing and you stop playing one of them (that is, say, you take your finger off a key on the keyboard but you still have other keys held down) the "last note" will continue to "play". this only works as this script is monophonic.
function remove_a_note_from_the_note_list(the_note_to_remove)
	-- iterate through the note list, in reverse order, to see if we can find the note to remove.
	for the_current_entry_in_note_list = #note_list, 1, -1 do
		-- if the note is found in the note list:
		if note_list[the_current_entry_in_note_list] == the_note_to_remove then
			-- then remove the note from the note list.
			table.remove(note_list, the_current_entry_in_note_list)
			-- no need to continue going through the note list now as there should only be one occurance of the note in the list, and we've just removed it.
			break -- it down
		end
	end
end
-- end of remove_a_note_from_the_note_list().

-- that's all, folks! thank you. you deserve a cup of tea and a hobnob!
