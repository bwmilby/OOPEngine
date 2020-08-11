Script "stack_Particles_group_id_22100"

/*
# Name: group "maxMinX" of group "controls" of card id 1002 of stack "Particles"
# ID: group id 22100 of group id 79210 of card id 1002 of stack "Particles"
# Behavior: button id 22102 of stack "Particles"
*/


on minValueChanged pValue
   setEmittorMinX pValue
   put pValue into field "xmin"
end minValueChanged

on MaxValueChanged pValue
   setEmittorMaxX pValue
   put pValue into field "xmax"
end MaxValueChanged
