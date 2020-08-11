Script "stack_Particles_button_id_137210"

/*
# Name: button "Point 2" of group "Line" of group "controls" of card id 1002 of stack "Particles"
# ID: button id 137210 of group id 137207 of group id 79210 of card id 1002 of stack "Particles"
*/


local isDragging

on mouseDown
   put true into isDragging
end mouseDown

on mouseMove px,py
   if isDragging then
      lock screen
      set the loc of me to px,py
      put the points of graphic "Line" into tPoints
      put (px,py) into line 2 of tPoints
      set the points of graphic "line" to tPoints
      replace return with comma in tpoints
      setEmittorType "line", tPoints 
   end if
end mouseMove

on mouseUp
   put false into isDragging
end mouseUp

on mouseRelease
   put false into isDragging
end mouseRelease
