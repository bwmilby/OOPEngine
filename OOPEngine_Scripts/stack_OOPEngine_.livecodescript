Script "stack_OOPEngine_"

/*
# Name: stack "OOPEngine"
# ID: stack "OOPEngine"
*/


###############################
# OOP Engine

# original by Håkan Liljegren 2012
# modified by Mark Wieder 2020

# classes are buttons, objects are groups
# dispatch has a tristate return value: handled, passed, unhandled
# added newClass and deleteClass operators
# added reference count for class deletion
# added class constructors and destructors
###############################

constant kVersion = 1.02
constant kClassStorage = "Classes"
constant kAllowCascadingDeletes = false

function OOPversion
   return "OOP Engine version" && kVersion
end OOPversion

function newClass pClassName, pSuperClass
   if exists(button pClassName of card kClassStorage) then
      throw "class" && pClassName && "already exists"
   else
      create button pClassName of card kClassStorage
      if pSuperClass is not empty then
         set the behavior of button pClassName to the long id of button pSuperClass of card kClassStorage
      end if
      return the id of button pClassName of card kClassStorage
   end if
end newClass

command deleteClass pClassName
   local tSuperClass
   
   if exists(button pClassName of card kClassStorage) then
      put the behavior of button pClassName into tSuperClass
      # not sure if deleting the superclass is a good idea either
      if kAllowCascadingDeletes then
         if tSuperClass is not empty then
            # if no object is using the superclass then recursively delete the superclass
            deleteClass tSuperClass
         end if
      end if
      # finally delete this class
      dispatch function "decrementReferenceCount" to button pClassName of card kClassStorage
      if the result is 0 then
         delete button pClassName of card kClassStorage
      else
         throw "Class" && pClassName && "is still in use, so can't be deleted"
      end if
   end if
end deleteClass

function decrementReferenceCount
   local tReferenceCount
   
   put the referenceCount of the target into tReferenceCount
   if tReferenceCount > 0 then
      subtract 1 from tReferenceCount
      set the referenceCount of the target to tReferenceCount
   end if
   return tReferenceCount
end decrementReferenceCount

command incrementReferenceCount
   local tReferenceCount
   
   put the referenceCount of the target into tReferenceCount
   if tReferenceCount is empty then
      put 1 into tReferenceCount
   else
      add 1 to tReferenceCount
   end if
   set the referenceCount of the target to tReferenceCount
end incrementReferenceCount

function newObject pClass, pName
   local tNewObject
   
   if exists(button pClass of card "Classes") then
      set the visible of the templategroup to false # Make it "truly" invisible
      set the margins of the templategroup to 0 # Make it "truly" invisible
      if pName is not empty then
         create group pName
      end if
      put the id of the last group into tNewObject
      set the behavior of control id tNewObject to the long id of button pClass of card kClassStorage
      reset the templategroup
      # call the class constructor if it exists
      dispatch "constructor" to control id tNewObject
      return the long id of control id tNewObject
   else
      throw "Class " & pClass & ": no such class"
   end if
end newObject

# example class constructor
command constructor pClass
   local tSuperClass
   if pClass is not empty then
      if pClass is not the short name of this me then
         pass constructor
      end if
   end if
   --
   # pass up the behavior chain first
   put the behavior of this me into tSuperClass
   if tSuperClass is not empty then
      dispatch "constructor" to me with the short name of tSuperClass
   end if
   --
   # then do the most local constructor tasks
   # put the short name of this me && param(0) && the id of the target & cr after msg
end constructor

# MDW 2020.08.04: deleting the owner object doesn't seem right
on deleteObject pObject
   if exists(pObject) then
      # call the class destructor if it exists
      dispatch "destructor" to pObject
      delete pObject
   else
      # Maybe we got just an object name?
      if exists(group pObject) then
         deleteObject(the long id of group pObject)
      else
         throw "Object " & pObject & ": no such object"
      end if
   end if
end deleteObject

# example class destructor
command destructor
   local tSuperClass
   put the behavior of this me into tSuperClass
   --
   # do the local destructor tasks first
   # put the short name of this me && param(0) && the id of the target & cr after msg
   --
   # then pass up the message chain
   if tSuperClass is not empty then
      pass destructor
   end if
end destructor

function messageObject pObject, pMethod
   local tParams
   local tCommand
   
   put empty into tParams
   repeat with i = 3 to the paramCount
      put param(i) & comma & space after tParams
   end repeat
   delete last char of tParams
   
   dispatch function pMethod to pObject with tParams
   if it is not "unhandled" then
      return the result
   else
      # Try command instead of function
      dispatch pMethod to pObject with tParams
      if it is not "unhandled" then
         return the result
      else
         throw "Object error: No method " & pMethod & " in class " & className(pObject)
      end if
   end if
end messageObject

--> introspection

function isObject? pObject
   if exists(pObject) and exists(the behavior of pObject) then
      if exists( button (the short name of the behavior of pObject) of card kClassStorage) then
         return true
      end if
   end if
   return false
end isObject?

function ClassName pObject
   if isObject?(pObject) then
      return the short name of the behavior of pObject
   else
      return empty
   end if
end ClassName

function isObjectOfClass? pObject, pClass
   if ClassName(pObject) is pClass then
      return true
   else
      return false
   end if
end isObjectOfClass?

# set the class of an existing control
on setClassForControl pControlID, pClassLongID
   if exists(pControlID) then
      if exists(pClassLongID) then
         set the behavior of pControlID to pClassLongID
      end if
   end if      
end setClassForControl

# OOP-engine
############################################
