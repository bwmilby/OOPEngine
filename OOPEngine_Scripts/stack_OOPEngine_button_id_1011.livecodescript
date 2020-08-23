Script "stack_OOPEngine_button_id_1011"

/*
# Name: button "Queue" of card "Classes" of stack "OOPEngine"
# ID: button id 1011 of card id 1010 of stack "OOPEngine"
*/


# LinkedList class
# this implements a queue (FILO)

local sListArray
local sCount
local sFirst, sLast

# each entry has
# an object
# a pointer to the next entry

command LinkedList
   put param(0) & cr after msg
   put 0 into sCount
   put 1 into sFirst
   put 0 into sLast
end LinkedList

function head
   return sListArray[sFirst]
end head

function tail
   return sListArray[sCount]
end tail

# queue functions
command queue.push pObject
   put sCount+1 into sListArray[sCount]
   add 1 to sCount
   put sCount into sLast
   put pObject into sListArray[sCount]["object"]
   put empty into sListArray[sCount]["next"]
end queue.push

function queue.pop
   local tObject
   
   put sListArray[sCount] into tObject
   delete variable sListArray[sCount]
   subtract 1 from sCount
   put empty into sListArray[sCount]["next"]
   return tObject
end queue.pop
