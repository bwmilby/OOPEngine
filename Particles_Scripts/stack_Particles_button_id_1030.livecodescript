Script "stack_Particles_button_id_1030"

/*
# Name: button "StartEmittor" of group "controls" of card id 1002 of stack "Particles"
# ID: button id 1030 of group id 79210 of card id 1002 of stack "Particles"
*/


on mouseUp
   if the label of me is "start emittor" then
      startSimulation
      set the label of me to "Stop emittor"
   else
      stopSimulation
      set the label of me to "Start emittor"
   end if
end mouseUp
