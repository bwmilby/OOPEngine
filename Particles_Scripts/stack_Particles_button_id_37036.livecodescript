Script "stack_Particles_button_id_37036"

/*
# Name: button "Follow Mouse X" of group "controls" of card id 1002 of stack "Particles"
# ID: button id 37036 of group id 79210 of card id 1002 of stack "Particles"
*/


on mouseUp
   set the visible of group "Line" to not (the hilite of me or the hilite of button "Follow Mouse Y")
end mouseUp
