Script "stack_Particles_button_id_22102"

/*
# Name: button "MaxMinScrollerBehavior" of card id 1002 of stack "Particles"
# ID: button id 22102 of card id 1002 of stack "Particles"
*/


local _dragObject
local _isDragging

setProp minValue pValue
   if pValue >= the valueStart of me and pValue <= the valueStop of me and pValue <= the maxValue of me then
      set the loc of graphic "MinValue" of me to the left of graphic "bar" of me +  \
            (pValue - the valueStart of me) / (the valueStop of me - the valueStart of me) * the width of graphic "Bar" of me,  \
            item 2 of the loc of graphic "MinValue" of me 
      setRange
   end if
end minValue

getProp minValue
   put item 1 of the loc of graphic "MinValue" of me into minX
   return round((minX - the left of graphic "bar" of me )/the width of graphic "Bar" of me *(the valueStop of me - the valueStart of me) +  \
         the valueStart of me)
end minValue

setProp maxValue pValue
   if pValue >= the valueStart of me and pValue <= the valueStop of me and pValue >= the minValue of me then
      set the loc of graphic "MaxValue" of me to the left of graphic "bar" of me + (pValue - the valueStart of me) / (the valueStop of me -  \
      the valueStart of me) * the width of graphic "Bar" of me , item 2 of the loc of graphic "MaxValue" of me
      setRange
   end if
end maxValue

getProp maxValue
   put item 1 of the loc of graphic "MaxValue" of me into maxX
   return round((maxX - the left of graphic "bar" of me )/the width of graphic "Bar" of me * (the valueStop of me - the valueStart of me) + \
         the valueStart of me)
end maxValue

on moveMinMarker pXPos
   if pXPos >= the left of graphic "Bar" of me and pXPos <= item 1 of loc of graphic "MaxValue" of me then
      set the loc of graphic "minValue" of me to pXPos, item 2 of the loc of me
      setRange
      dispatch "MinValueChanged" to me with the minValue of me
   end if
end moveMinMarker

on moveMaxMarker pXPos
   if pXPos <= the right of graphic "Bar" of me and pXPos >= item 1 of loc of graphic "MinValue" of me then
      set the loc of graphic "maxValue" of me to pXPos, item 2 of the loc of me
      setRange
      dispatch "MaxValueChanged" to me with the maxValue of me
   end if
end moveMaxMarker

on setRange
   lock screen
   set the width of graphic "Range" of me to item 1 of the loc graphic "MaxValue" of me - item 1 the loc of graphic "minValue" of me
   set the height of graphic "Range" of me to the height of graphic "bar" of me 
   set the topleft of graphic "Range" of me to item 1 of the loc of graphic "minValue" of me, the top of graphic "Bar" of me
   unlock screen
end setRange

on mouseDown
   if the short name of the target is "MinValue" then
      put the long id of graphic "minValue" into _dragObject
      put true into _isDragging
   else if the short name of the target is "MaxValue" then
      put the long id of graphic "maxValue" into _dragObject
      put true into _isDragging
   end if
end mouseDown

on mouseMove pX, pY
   if _isDragging then
      if the short name of _dragObject is "minValue" then
         moveMinMarker pX
      else
         moveMaxMarker pX
      end if
   end if
end mouseMove

on mouseUp
   put false into _isDragging
end mouseUp

on mouseRelease
   put false into _isDragging
end mouseRelease

on resizeControl
   lock screen
   put the maxValue of me into myMax
   put the minValue of me into myMin
   lock messages
   put the height of me - 2 * the margins of me into trueHeight
   put the width of me - 2 * the margins of me into trueWidth
   set the height of graphic "bar" of me to round(trueHeight * 0.7)
   set the width of graphic "bar" of me to trueWidth
   set the loc of graphic "bar" of me to the loc of me
   set the width of graphic "MaxValue" of me to trueHeight
   set the height of graphic "MaxValue" of me to trueHeight
   set the width of graphic "minValue" of me to trueHeight
   set the height of graphic "minValue" of me to trueHeight
   unlock messages
   set the minValue of me to myMin
   set the maxValue of me to myMax
   setRange
   unlock screen
end resizeControl

