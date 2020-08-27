Script "stack_Particles_"

/*
# Name: stack "Particles"
# ID: stack "Particles"
*/


on preOpenStack
   if "OOPEngine" is among the lines of the openStacks then
      start using stack "OOPengine"
      registerClasses the long id of card "Classes", true
      registerClass the long id of stack "Emittor", true
   else
      answer "This stack requires the OOPEngine to run"
   end if
end preOpenStack
