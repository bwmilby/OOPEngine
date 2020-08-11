Script "stack_Particles_"

/*
# Name: stack "Particles"
# ID: stack "Particles"
*/


on preOpenStack
   if "OOPEngine" is among the lines of the openStacks then
      start using stack "OOPengine"
   else
      answer "This stack requires the OOPEngine to run"
   end if
end preOpenStack
