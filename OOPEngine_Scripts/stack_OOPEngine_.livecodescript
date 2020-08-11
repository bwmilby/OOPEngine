Script "stack_OOPEngine_"

/*
# Name: stack "OOPEngine"
# ID: stack "OOPEngine"
*/


###############################
# OOP Engine
function newObject pClass pName
   local parentObject, newObject
   if exists(button pClass of card "Classes") then
      if the parent of button pClass of card "Classes" is not empty then
         put newObject(the parent of button pClass of card "classes") into parentObject
      end if
      if parentObject is not empty then
         create group pName in parentObject
      else
         create group pName
      end if
      put the long id of the last group into tID
      set the margins of tID to 0 # Make it "truly" invisible
      set the behavior of tID to the long id of button pClass of card "Classes"
      return the long id of the last group
   else
      throw "Class " & pClass & " definition doesn't exists"
   end if
end newObject

on deleteObject pObject
   if exists(pObject) then
      put the owner of pObject into ownerObject
      delete pObject
      if ownerObject begins with "group" then
         deleteObject ownerObject
      end if
   else
      # Maybe we got just an object name?
      if exists(group pObject) then
         deleteObject(the long id of group pObject)
      else
         throw "Object " & pObject & " doesn't exists"
      end if
   end if
end deleteObject

function messageObject pObject, pMethod
   put empty into tParams
   repeat with i = 3 to the paramCount
      do ("put param(i) into tArr" & i)
      put "tArr" & i & comma after tParams
   end repeat
   delete last char of tParams
   put "dispatch function" && quote & pMethod & quote && "to" && pObject && "with" && tParams into tCommand
   do tCommand
   if it is "handled" then
      return the result
   else
      # Try command instead of function
      put "dispatch " & quote & pMethod & quote & " to " & pObject & " with " & tParams into tCommand
      do tCommand
      if it is "handled" then
         return the result
      else
         throw "Object error: No method " & pMethod & " in class " & className(pObject)
      end if
   end if
end messageObject

function isObject pObject
   if exists(pObject) and exists(the behavior of pObject) then
      if exists( button (the short name of the behavior of pObject) of card "Classes") then
         return true
      end if
   end if
   return false
end isObject

function ClassName pObject
   if isObject(pObject) then
      return the short name of the behavior of pObject
   else
      return empty
   end if
end ClassName

function isObjectOfClass pObject, pClass
   if ClassName(pObject) is pClass then
      return true
   else
      return false
   end if
end isObjectOfClass

on setClassForControl pControlID, pClass
   if exists(pControlID) then
      lock screen
      # First create class container
      put newObject(pClass) into tInstance
      # Now move control into the newly created instance
      cut pControlID
      start editing tInstance
      paste
      stop editing tInstance
      unlock screen
   end if      
end setClassForControl

# OOP-engine
############################################
