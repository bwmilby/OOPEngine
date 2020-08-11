Script "stack_Particles_group_id_22105"

/*
# Name: group "maxMinY" of group "controls" of card id 1002 of stack "Particles"
# ID: group id 22105 of group id 79210 of card id 1002 of stack "Particles"
# Behavior: button id 22102 of stack "Particles"
*/


on minValueChanged pValue
   setEmittorMinY pValue
   put pValue into field "ymin"
end minValueChanged

on MaxValueChanged pValue
   setEmittorMaxY pValue
   put pValue into field "ymax"
end MaxValueChanged
