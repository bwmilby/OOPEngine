Script "stack_OOPEngine_button_id_1009"

/*
# Name: button "Use" of card id 1002 of stack "OOPEngine"
# ID: button id 1009 of card id 1002 of stack "OOPEngine"
*/


on mouseUp
   if the hilite of me then
      start using stack the short name of this stack
   else
      stop using stack the short name of this stack
   end if
end mouseUp
