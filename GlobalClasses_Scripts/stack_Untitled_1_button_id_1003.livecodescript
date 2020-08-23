Script "stack_Untitled_1_button_id_1003"

/*
# Name: button "Button_1" of card id 1002 of stack "Untitled 1"
# ID: button id 1003 of card id 1002 of stack "Untitled 1"
*/


-- Sent when the mouse is released after clicking
-- pMouseButton specifies which mouse button was pressed
on mouseUp pMouseButton
   local tNewObject
   
   # create an invisible linkedlist group class object on this stack
   put newObject("list1", "LinkedList") into tNewObject
   put the name of tNewObject & cr after msg
end mouseUp
